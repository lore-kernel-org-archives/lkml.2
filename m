Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1EQIqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:46:16 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42036 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1EQIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=lOUOx3bxY7y633kOJ/jLkUL/kVcLo0qAw+Km1kyyWkz2zsHeTglVx6zmTSfljkbphH
         v2NxOIucTNq+e8OhvlN3+rqJQ55mbWh7M5mxJ2kBrWk3a1WkGGE9Pesr1zMTh3Xc9bHe
         rTRPzbf1nucfnAssSppgAPAFOhYOEALDiY7pg=
From: Florian Fainelli <florian@openwrt.org>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Date: Tue, 17 May 2011 10:50:38 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-server; KDE/4.6.2; x86_64; ; )
Cc: Tony Ibbs <tibs@tonyibbs.co.uk>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Linux-embedded" <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net>
In-Reply-To: <20110322133640.5d5c88e4@bike.lwn.net>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105171050.38903.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for this late answer.

On Tuesday 22 March 2011 20:36:40 Jonathan Corbet wrote:
> On Fri, 18 Mar 2011 17:21:09 +0000
> 
> Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
> > KBUS is a lightweight, Linux kernel mediated messaging system,
> > particularly intended for use in embedded environments.
> 
> I've spent a bit of time looking at this code...this isn't a detailed
> review by any stretch, more like a few impressions.
> 
> - Why kbus over, say, a user-space daemon and unix-domain sockets?  I'm
>   not sure I see the advantage that comes with putting this into kernel
>   space.

I also fail to see why this would be required. In my opininon you are trading 
the reliability over complexity by putting this in the kernel.

Most implementations (if not all) involving system-wide message delivery for 
other daemons are running in user-space. Having a daemon for message delivery 
to other kbus clients/servers does not not seem less reliable to me. If you 
had in mind that this daemon might be killed under OOM conditions, then maybe 
your whole system has an issue, issue which could be circumvented by making 
sure the messaging process gets respawned when possible (upstart like 
mechanism or such).

> 
> - The interface is ... creative.  If you have to do this in kernel space,
>   it would be nice to do away with the split write()/ioctl() API for
>   reading or writing messages.  It seems like either a write(), OR an
>   ioctl() with a message data pointer would suffice; that would cut the
>   number of syscalls the applications need to make too.
> 
>   Even better might be to just use the socket API.

Indeed, I would also suggest having a look at what generic netlink already 
provides like messages per application PID, multicasting and marshaling. If 
you intend to keep a part of it in the kernel, you should have a look at this, 
because from my experience with generic netlink, most of the hard job you are 
re-doing here, has already been done in a generic manner.

> 
> - Does anything bound the size of a message fed into the kernel with
>   write()?  I couldn't find it.  It seems like an application could
>   consume arbitrary amounts of kernel memory.
> 
> - It would be good to use the kernel's dynamic debugging and tracing
>   facilities rather than rolling your own.
> 
> - There's lots of kmalloc()/memset() pairs that could be kzalloc().
> 
> That's as far as I could get for now.
> 
> Thanks,
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-embedded"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
