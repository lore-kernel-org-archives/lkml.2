Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2BCQsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:48:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44555 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2BCQs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:48:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120203160454.GA3092@redhat.com>
References: <20120203154411.GB2471@osiris.boeblingen.de.ibm.com> <20120203160454.GA3092@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Feb 2012 08:48:08 -0800
X-Google-Sender-Auth: H8FHnPnq4H8-ARsbpNvHV3iWeGI
Message-ID: <CA+55aFx0SxW5ST2H1TL6K-457nP1qtAva0+YcnJLNoUUz_PCdg@mail.gmail.com>
Subject: Re: cgroup_release_agent() with call_usermodehelper() with
 UMH_WAIT_EXEC may crash
To: Oleg Nesterov <oleg@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 8:04 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Can't we simply move that code into flush_old_exec() ? (wrapped into
> the new helper).

Sure. It would kind of make sense to do it as part of exec_mmap().
That's what associates us with the new mm, after all.

That said, I think my *preferred* approach would be to still do the final

    set_task_comm(current, tcomm);

in setup_new_exec(), because that's really when we set up the new mm.

So my preferred solution would be to simply move the "char tcomm[];"
array from the stack (currently automatic in setup_new_exec()) into
the struct linux_binprm, and then copy it from the filename early. We
could copy it arbitrarily early, perhaps in "prepare_binprm()".

Hmm?

                       Linus
