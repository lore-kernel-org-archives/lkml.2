Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1LVO7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:59:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1LVO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:59:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: NeilBrown <neilb@suse.de>
Subject: Re: RFC: android logger feedback request
Date: Thu, 22 Dec 2011 14:59:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Tim Bird <tim.bird@am.sony.com>, Greg KH <gregkh@suse.de>,
        "linux-embedded" <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
References: <4EF264C3.6000104@am.sony.com> <4EF27B85.9080801@am.sony.com> <20111222122026.3a0fae36@notabene.brown>
In-Reply-To: <20111222122026.3a0fae36@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112221459.04701.arnd@arndb.de>
X-Provags-ID: V02:K0:zkiRaOprncIfIkbIZcgW4gC1H7Xfk5uPCcgMH/Pwwhv
 05FUGMdFfXQuNo1OkIDOeG1/V/JA4iK/K3IZAFCoEsSJtKD7wY
 +DJGji88NqGfLMLh8o8lWFgpwsQFq/vQ6xOm++z/tRSgKA7lHo
 WfsjD8cSFNtMDZT0WRyr1Gt/XdpBP4hhCuuoE1DqJbgh5xaP3s
 L3WZQHTjPOCzalOpzLzNKppLezlUjwCXiRU/dTZhm6FCE1aWT/
 2e/FqRaiatj01e8bPjeLLX1jGMSlB2dcUi4GzQeVtcX/abSlTh
 bNtubQXWTXpcKuCzZs+tP6b7FaMkLMiJ4lE3fWQ+U2HitoWEw9
 Q+A1FGu1HKSDajA4gr74=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 December 2011, NeilBrown wrote:
> If you created a 'logbuf' filesystem that used libfs to provide a single
> directory in which privileged processes could create files then you wouldn't
> need the kernel to "know" the allowed logs: radio, events, main, system.
> The size could be set by ftruncate() (by privileged used again) rather than
> being hardcoded.
> 
> You would defined 'read' and 'write' much like you currently do to create a list of
> datagrams in a circular buffer and replace the ioctls by more standard
> interfaces:
> 
> LOGGER_GET_LOG_BUG_SIZE would use 'stat' and the st_blocks field
> LOGGER_GET_LOG_LEN would use 'stat' and the st_size field
> LOGGER_GET_NEXT_ENTRY_LEN could use the FIONREAD ioctl
> LOGGER_FLUSH_LOG could use ftruncate
> 
> The result would be much the same amount of code, but an interface which has
> fewer details hard-coded and is generally more versatile and accessible.

I like the idea and was going to suggest something very similar, but I wonder
if we could take the approach even further:

* Remove all kernel code for this and use a user space library together
  with tmpfs
* prepopulate the tmpfs at boot time with all the log buffers in the right
  size, and set the maximum file system size so that they cannot grow further.
* Have minimal formatting in the log buffer: A few bytes header (ring buffer
  start and end)
* Mandate that user space must use mmap and atomic operations to reserve space
  in the log and write to the files.
* Provide a tool to get the log data out of the buffer again in a race-free way.

Since any program that is allowed to write to the buffer can overwrite all
existing information in it anyway, I think we don't actually need any kernel
help in maintaining consistency of the contents either -- the reader will
simply discard any data. The main thing we would not be able to guarantee
without kernel help is proving the origin of individual messages, but I'm
not sure if that is a design goal.

	Arnd
