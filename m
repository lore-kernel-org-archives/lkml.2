Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2JSMTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:19:39 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:37797 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2JSMTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:19:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] linux/time.h vs. sys/time.h mess (was [PATCH 1/2] [media] remove include/linux/dvb/dmx.h)
Date: Fri, 19 Oct 2012 14:20:25 +0200
Message-ID: <1866001.vORa2QqSgB@avalon>
User-Agent: KMail/4.9.2 (Linux/3.4.9-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121019082116.145ebe92@redhat.com>
References: <1350643392-2193-1-git-send-email-mchehab@redhat.com> <20121019082116.145ebe92@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

(CC'ing LKML)

On Friday 19 October 2012 08:21:16 Mauro Carvalho Chehab wrote:
> Em Fri, 19 Oct 2012 07:43:11 -0300
> 
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> > -#include <linux/time.h>
> > -#include <uapi/linux/dvb/dmx.h>
> > -
> > -#endif /*_DVBDMX_H_*/
> 
> Just to not discard a valid comment on IRC, Laurent proposed that we
> should investigate if we can, instead, move:
> 
> 	#include <linux/time.h>
> 
> to both dmx.h and videodev2.h, letting it to be included by both userspace
> and Kernelspace.
> 
> I remember this used to cause compilation breakage in the past, as some
> userspace programs need to include <sys/time.h> and this used to conflict
> with <linux/time.h>.
> 
> I'm not sure if this got fixed there. if so, Laurent has a point.

It's still not solved, but that's what the proper fix should be.

Several UAPI headers use struct timeval or struct timespec. Kernel code and 
user space code thus need to include the header(s) that define those 
structures, either directly or indirectly.

In kernel space struct timeval and struct timespec are defined in 
include/uapi/linux/time.h. In user space they're defined in <sys/time.h>. No 
proper conditional compilation exists in those headers to guard against 
multiple definitions, so they can't be included together.

On the kernel side <sys/time.h> isn't available, so we can include 
<linux/time.h> in the headers that use the timeval and timespec structures. 
This "self-contained" headers mechanism avoids forcing all users of those 
headers to explicitly include <linux/time.h>.

However, this then breaks user space applications that include both 
<sys/time.h> and a kernel header that includes <linux/time.h>. The way we've 
dealt with that until now is by including either <linux/time.h> or 
<sys/time.h> depending on __KERNEL__

#ifdef __KERNEL__
#include <linux/time.h>
#else
#include <sys/kernel.h>
#endif

in our user-facing headers. The recent UAPI disintegration patches resulted in 
nearly empty headers in include/linux/ that just #include both <linux/time.h> 
and the corresponding UAPI header. For instance include/linux/videodev2.h is 
now just

#ifndef __LINUX_VIDEODEV2_H
#define __LINUX_VIDEODEV2_H

#include <linux/time.h>     /* need struct timeval */
#include <uapi/linux/videodev2.h>

#endif /* __LINUX_VIDEODEV2_H */

Patches have been posted to remove those headers and push the #include 
<linux/time.h> one level up, which breaks the "self-contained" headers 
concept.

How could we fix this ? Are there legitimate users of <linux/time.h> in user 
space ? A quick grep in glibc doesn't reveal anything.

-- 
Regards,

Laurent Pinchart

