Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0KORE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:04:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49349 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab0KORE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop>
	<AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
	<1289677904.16461.82.camel@Joe-Laptop>
	<AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
Date: Mon, 15 Nov 2010 12:04:39 -0500
Message-ID: <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 3:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> We had this exact problem with the whole "mmap_min_addr" thing. People
> _thought_ of it as generic, but because it was actually tested by the
> security logic, if you ended up enabling SELinux the test actually
> went away entirely (or maybe it was the other way around). So with
> certain security models, the whole thing was bypassed, and the
> security module actually became an _IN_security module.

Your recollection is wrong, although your conclusions of the
ramifications are right.  Either SELinux or capabilities checked
mmap_min_addr, depending on which was 'primary.'  Just as they are
different modules they checked for different things.  Only doing
SELinux checks was stronger for some situations, and only doing
capability checks was stronger in some ways (and the reverse was
obviously true).  Today you get the best of both worlds since we
really have 2 different mmap_min_addr values...

In any case the result of that is that LSMs (ok 'I') need to be more
careful making sure they interact properly with the generic
capabilities hooks.

From: James Morris
> I want to ensure that LSMs which implement security_syslog can't end up
> with a less secure system than the default, regardless of whether they
> call cap_syslog or not.

Which really means that this is total crap.  If you don't call
cap_syslog() you broke it.  That's all there is to it.  Calling the
capability code is always required.  full stop.

I think this patch is broken though.  SELinux and SMACK don't care
about from_file and want to check every time no matter what.  Your
patch breaks that and only will call the LSM on occasion.  It's only
capabilities that likes those semantics.  I think the entire contents
of the cap_syslog hook should be moved up and that hook just dropped
entirely.

I'll code up what I'm thinking in a minute.....

-Eric
