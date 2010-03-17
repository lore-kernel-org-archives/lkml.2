Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0CQXrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:47:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:45449 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0CQXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:47:18 -0400
Subject: Re: [PATCH] perf_events: fix bug in AMD per-cpu initialization
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
References: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 00:47:11 +0100
Message-ID: <1268869631.9440.282.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 10:40 +0200, Stephane Eranian wrote:
> 	On AMD processors, we need to allocate a data structure per Northbridge
> 	to handle certain events.
> 
> 	On CPU initialization, we need to query the Northbridge id and check
> 	whether the structure is already allocated or not. We use the
> 	amd_get_nb_id() function to request the Northbridge identification.
> 
> 	The recent cleanup of the CPU online/offline initialization introduced
> 	a bug. AMD cpu initialization is invoked on CPU_UP_PREPARE callback.
> 	This is before the CPU Northbridge id is calculated. Therefore no
> 	processor had a Northbridge structure allocated except the boot
> 	processor. That was causing bogus NB event scheduling.
> 
> 	This patch uses the CPU_ONLINE callback to initialize the AMD
> 	Northbridge structure. This way amd_get_nb_id() returns valid
> 	information.
> 
> 	The x86_cpu_up() callback was added. Could not call it cpu_online
> 	because of existing macro.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>


No, ONLINE is not exposed for a good reason, its always wrong.

Use prepare to allocate data, and starting to initialize stuff on the
cpu proper once its up. Online is after the cpu is up and running and we
are already scheduling stuff on it so its too late to initialize things.

