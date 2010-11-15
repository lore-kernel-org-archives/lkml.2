Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab0KOSV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:21:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933449Ab0KOSV5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:21:57 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
 <1289677904.16461.82.camel@Joe-Laptop> <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
 <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
 <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
 <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com> <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 10:20:56 -0800
Message-ID: <AANLkTim5wGt5SZkOJWDMWhS7FSPyEE1xpirpb0bqN9BS@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
To: Eric Paris <eparis@parisplace.org>
Cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 9:45 AM, Eric Paris <eparis@parisplace.org> wrote:
>
> That is the rule for ALL of the hooks in commoncap.c.  The one time I
> tried to do something else *cough*mmap_min_addr*cough* I screwed it
> up.  I'll put a note in my todo list about looking into lifting all of
> commoncap.c into the callers.

Into "security/security.c" itself? That would work, except it doesn't
work exactly in a situation like this where the whole interface was
polluted by the commoncap version simply having fundamentally
different semantics (ie the whole "no security check at read time,
only at open time"). Passing the whole "from_file" thing around was
just ugly.

And while passing the commoncap cases down into the callers of the
"security_xyz()" interface itself makes sense in this case, I don't
think it makes sense in general. With 'security_syslog()' there really
was just one very specific call-site. Other security wrappers have
many more (eg "security_vm_enough_memory()") call sites, and moving
the cap_xyz() code to those callsites would be totally wrong
duplication.

                        Linus
