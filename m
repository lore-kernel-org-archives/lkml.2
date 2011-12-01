Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1LAQLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:11:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55697 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1LAQLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:11:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111201142704.GT4387@parisc-linux.org>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
 <20111201122425.GA16274@localhost> <20111201142704.GT4387@parisc-linux.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Dec 2011 08:10:47 -0800
X-Google-Sender-Auth: Bw9Tv9LYX-jvA_oaj61ePH_8yqI
Message-ID: <CA+55aFypH2+MQOZfn8qoO7zo_17Oo8jLaayye45pgo_Hpz2jBQ@mail.gmail.com>
Subject: Re: [PATCH] fs: Make write(2) interruptible by a fatal signal
To: Matthew Wilcox <matthew@wil.cx>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 6:27 AM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> Another problem scenario is an NFS mounted file going away while the
> user is writing to it.  The user should be able to kill the stuck process
> without rebooting their machine.

Well, NFS has always had the 'intr' mount option.

The problem with NFS and 'intr' is that it's very user-visible, and
makes even nonfatal signals cause EINTR. So the "abort writes on fatal
signals" is a lot less noticeable to any programs: sure, it does
introduce potentially visible semantic changes, but now they are
visible only across different processes, not within one process.

And anybody who relies on "all or nothing" even in the face of SIGKILL
is just broken. That said, like so many changes, I think this falls
solidly on the "we should do this, but if somebody reports a
regression..."

I suspect the likelihood of regressions is basically zero. No
application that actually cares about its data would ever rely on the
"writes will complete entirely or not at all" semantics. Not only has
it never been true on NFS, but it's not true in the face of crashes
either, so any careful app will already depend on other things like
fsync+rename etc.

                           Linus

                          Linus
