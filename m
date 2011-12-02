Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1LBNtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:49:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab1LBNtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:49:18 -0500
Date: Fri, 2 Dec 2011 08:49:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [patch]cfq-iosched: fix cfq_cic_link() race confition
Message-ID: <20111202134913.GA28102@redhat.com>
References: <4ED886DC.1000608@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED886DC.1000608@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 05:05:48PM +0900, Yasuaki Ishimatsu wrote:
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
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Looks good to me.  Thanks.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

