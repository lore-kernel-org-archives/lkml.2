Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab1JRBUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:20:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38988 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab1JRBUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Oct 2011 18:20:20 -0700
X-Google-Sender-Auth: ncYkyiluPly9KA_xNB_B4wyekV4
Message-ID: <CA+55aFxj+heCCoQx0ecVyCE0b5e3fGpAUPSUH8K7E=TyRzNSUg@mail.gmail.com>
Subject: Re: [patch] Avoid using hardcoded values in kernel/sys.c
To: David Rientjes <rientjes@google.com>
Cc: Henrik Grindal Bakken <henribak@cisco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 5:55 PM, David Rientjes <rientjes@google.com> wrote:
> The release field of struct new_utsname may always change, so avoid
> hardcoded values when setting up a buffer to copy to it.

This patch is totally bogus.

> +static int override_release(char __user *release)
>  {
> +       const int len = sizeof(release);

You just wrote "len = 4" (or 8, for 64-bit architectures) in a very unclear way.

IOW, "len" is now the size of the *pointer*. Which is wrong.

*And* you then re-introduced the variable-length array, which not only
triggered the gcc bug, but which is a BAD IDEA TO BEGIN WITH.

Variably sized arrays generate worse code, and can have subtle
security issues that aren't obvious (like cause our tools that check
for overly big stack usage to quietly fail).

Don't use variable-sized arrays on stack. They are never a good idea
in kernel space. The fact that we do have other code that does use
them too is not an excuse.

But using them in this kind of horribly broken manner with the wrong
length is just *really* bad.

                           Linus
