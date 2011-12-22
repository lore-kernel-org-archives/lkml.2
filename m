Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1LVPOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:14:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42293 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1LVPN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:13:58 -0500
MIME-Version: 1.0
In-Reply-To: <201112221459.04701.arnd@arndb.de>
References: <4EF264C3.6000104@am.sony.com> <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown> <201112221459.04701.arnd@arndb.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 22 Dec 2011 16:13:37 +0100
Message-ID: <CAPXgP12jQg+n=-=R+K8J+5Np97QesoKRApxaRtYvd1Jf-LnhzA@mail.gmail.com>
Subject: Re: RFC: android logger feedback request
To: Arnd Bergmann <arnd@arndb.de>
Cc: NeilBrown <neilb@suse.de>, Tim Bird <tim.bird@am.sony.com>,
        Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 15:59, Arnd Bergmann <arnd@arndb.de> wrote:

> * Remove all kernel code for this and use a user space library together
>  with tmpfs
> * prepopulate the tmpfs at boot time with all the log buffers in the right
>  size, and set the maximum file system size so that they cannot grow further.
> * Have minimal formatting in the log buffer: A few bytes header (ring buffer
>  start and end)
> * Mandate that user space must use mmap and atomic operations to reserve space
>  in the log and write to the files.
> * Provide a tool to get the log data out of the buffer again in a race-free way.
>
> Since any program that is allowed to write to the buffer can overwrite all
> existing information in it anyway, I think we don't actually need any kernel
> help in maintaining consistency of the contents either -- the reader will
> simply discard any data. The main thing we would not be able to guarantee
> without kernel help is proving the origin of individual messages, but I'm
> not sure if that is a design goal.

I'm very sure you want rate limiting, global sequence numbers and
trusted properties added to the log.

I can imagine that the kernel provides a single character device,
instantiates a tmpfs mountpoint and splits all stuff that travels into
that device into several files (ring buffers) in the tmpfs filesystem.
The files are probably just split by the uid of the incoming message
sender, which maps to an app at Android.

Only the character device would be able to write to the file, but the
user with the matching uid can read its own file back directly from
tmpfs.

I'm very convinced that we should not design a logging system today,
where we give the ownership of the data to the actual untrusted
process that logs.

The current kmsg buffer could just be one additional file in this tmpfs mount.

Kay
