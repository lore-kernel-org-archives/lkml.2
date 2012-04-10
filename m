Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab2DJBXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:23:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54928 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab2DJBXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204091655470.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
	<CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
	<alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
	<CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com>
	<alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1204091655470.21813@chino.kir.corp.google.com>
Date: Mon, 9 Apr 2012 18:23:02 -0700
Message-ID: <CAMbhsRS5SxLdKXNS6YW+2zM_Zc6v1Fs_JdqX3nCeb9BwDXTMpw@mail.gmail.com>
Subject: Re: [patch] android, lowmemorykiller: remove task handoff notifier
From: Colin Cross <ccross@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 4:56 PM, David Rientjes <rientjes@google.com> wrote:
> The task handoff notifier leaks task_struct since it never gets freed
> after the callback returns NOTIFY_OK, which means it is responsible for
> doing so.
>
> It turns out the lowmemorykiller actually doesn't need this notifier at
> all.  It's used to prevent unnecessary killing by waiting for a thread to
> exit as a result of lowmem_shrink(), however, it's possible to do this in
> the same way the kernel oom killer works by setting TIF_MEMDIE and avoid
> killing if we're still waiting for it to exit.
>
> The kernel oom killer will already automatically set TIF_MEMDIE for
> threads that are attempting to allocate memory that have a fatal signal.
> The thread selected by lowmem_shrink() will have such a signal after the
> lowmemorykiller sends it a SIGKILL, so this won't result in an
> unnecessary use of memory reserves for the thread to exit.
>
> This has the added benefit that we don't have to rely on CONFIG_PROFILING
> to prevent needlessly killing tasks.
>
> Reported-by: werner <w.landgraf@ru.ru>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |   48 +++++------------------------
>  1 file changed, 7 insertions(+), 41 deletions(-)
>

I did a quick test to measure the difference in time spent inside
lowmem_shrink with and without this patch, and they were about the
same.  So,
Acked-by: Colin Cross <ccross@android.com>
