Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588Ab2EQWqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:46:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62054 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030492Ab2EQWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 15:45:36 -0700
X-Google-Sender-Auth: HDZv9SbAuTKmMxQnrccL6V1TZBE
Message-ID: <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:10 AM, Luck, Tony <tony.luck@intel.com> wrote:
> Linus: Sent this to you on Monday as a patch:

So I really didn't like the patch.

I'm not entirely sure why I dislike it so much, but I don't like how
it seems to mix up the software rules and the hardware rules. They are
two totally separate things.

Also, the whole "nonrestartable state flag" means - if I understood
things correctly - that you really cannot do the "iret" even from the
NMI handler. So trying to push this into the whole process
notification seems entirely incorrect, because that still requires
that we return from the NMI - using the very machine state that we're
not supposed to use.

So I seriously believe the patch is wrong.

What I think *could* be right is something that says

 - if the "can't restart" flag is set *AND* the state saved is
user-space, then we can treat the NMI as a regular interrupt (because
we're clearly not interrupting kernel mode), and we can kill the
process directly.

 - if "can't restart" is set, and we're in kernel mode, we need to
panic (or, perhaps, just say "screw it, we don't have any choice,
we're going to try to restart anyway")

I guess the notify bit kind of emulates that "if the NMI happened in
user space" thing, but it seems to really do that more by mistake than
by design. Or at least it doesn't seem to be explicitly documented as
being intentional.

I dunno. I'm just very uncomfortable with the patch.

                   Linus
