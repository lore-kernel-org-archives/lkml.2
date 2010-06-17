Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab0FQW2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:28:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38652 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753097Ab0FQW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:28:47 -0400
Date: Thu, 17 Jun 2010 23:30:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617233054.330256cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617215105.GB24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
	<20100617000120.13071be8@lxorguk.ukuu.org.uk>
	<20100616232230.GP24749@outflux.net>
	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
	<20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
	<20100617140630.c6ced27a.rdunlap@xenotime.net>
	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
	<20100617215105.GB24749@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The "just use SELinux" reply is tiresome.  If "everyone" used SELinux,
> there wouldn't be at least 3 other LSMs under active development.

People using SELinux, SMACK and the other LSMs already *have* this
feature (done right, unlike the version you posted).

> The PTRACE, symlink, and other stuff are features people want.  If the
> point of your argument is that the logic and configuration for each
> of these features should be added to every LSM, that's not sensible.
> An end user should be able to pick and choose what they want.  If I
> create the security/hideous/ LSM tree, it would _exclude_ the ability to
> use TOMOYO or Smack or SELinux or AppArmor.

This is like trying to have two different file systems on the same
partition at once. We tried stackability - the reason LSMs don't currently
stack neatly is because it turned out to be a very bad idea.

If you want to fix that by implementing a stacking LSM which has your
switches then do that.

> At present, I'm aware of global PTRACE control being possible in SELinux,
> AppArmor, grsecurity, and as a patch in Ubuntu's kernel.  I don't know
> about TOMOYO or Smack, but configuring the default scope of PTRACE in
> at least 4 different ways so far (or not being able to change it at all)
> just seems crazy.

So you want to add a fifth. It won't replace the others because its not
as flexible. How does having five help ?

> If the security API allowed the end user to pick and choose the features
> they wanted, then those features would be developed in a single place
> and configured in a single way.  Since that's not possible, I'm proposing
> these features be central, and configured via /proc/sys.

They *are* central, which is why we have the security directory and the
security hooks abstracted into one central location.

So if you care about everyone then do it right - put it in its own LSM.
After that or in parallel you can look at how it needs to interact to
make it stackable. That's a door that the integrity/ima work has partly
re-opened already.

Really you have three choices

- You can keep trying to put stuff in places it doesn't belong, in which
  case you'll keep getting NAKs from people like Christoph and from Al
  Viro and then give up.

- You can give up now.

- You can put it together as a security module - which will make people
  happy and get your stuff upstream. After that you can have a meaningful
  discussion about stacking, although I think you'll find that stacking
  is really really hard because you get conflicting behaviour between
  security modules and ignoring those conflicts ends up violating at least
  one of the security models leaving you worse not better off.

Your path to making any of the stuff you want happen is via the security
layer and the LSM hooks. Even if you want them stackable and usable with
other modules your starting point is still a security module.

Alan
