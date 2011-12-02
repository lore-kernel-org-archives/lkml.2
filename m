Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1LBJFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:05:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1LBJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:05:21 -0500
Message-ID: <4ED894CB.80005@kernel.dk>
Date: Fri, 02 Dec 2011 10:05:15 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch]cfq-iosched: fix cfq_cic_link() race confition
References: <4ED886DC.1000608@jp.fujitsu.com>
In-Reply-To: <4ED886DC.1000608@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-02 09:05, Yasuaki Ishimatsu wrote:
> cfq_cic_link() has race condition. When some processes which shared ioc
> issue I/O to same block device simultaneously, cfq_cic_link() returns -EEXIST
> sometimes. The race condition might stop I/O by following steps:
> 
> step  1: Process A: Issue an I/O to /dev/sda
> step  2: Process A: Get an ioc (iocA here) in get_io_context() which does not
> 		    linked with a cic for the device
> step  3: Process A: Get a new cic for the device (cicA here) in
> 		    cfq_alloc_io_context()
> 
> step  4: Process B: Issue an I/O to /dev/sda
> step  5: Process B: Get iocA in get_io_context() since process A and B share the
> 		    same ioc
> step  6: Process B: Get a new cic for the device (cicB here) in
> 		    cfq_alloc_io_context() since iocA has not been linked with a
> 		    cic for the device yet
> 
> step  7: Process A: Link cicA to iocA in cfq_cic_link()
> step  8: Process A: Dispatch I/O to driver and finish it
> 
> step  9: Process B: Try to link cicB to iocA in cfq_cic_link()
> 		    But it fails with showing "cfq: cic link failed!" kernel
> 		    message, since iocA has already linked with cicA at step 7.
> step 10: Process B: Wait for finishig I/O in get_request_wait()
> 		    The function does not wake up, when there is no I/O to the
> 		    device.
> 
> When cfq_cic_link() returns -EEXIST, it means ioc has already linked with cic.
> So when cfq_cic_link() return -EEXIST, retry cfq_cic_lookup().

Thanks, your analysis and fix looks correct. Good work! Applied.

-- 
Jens Axboe

