Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1ISQLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:11:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60535 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab1ISQLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110919155718.GB16272@albatros>
References: <20110910164001.GA2342@albatros>
	<20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
	<CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
	<20110919144657.GA5928@albatros>
	<CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
	<20110919155718.GB16272@albatros>
Date: Mon, 19 Sep 2011 19:11:22 +0300
X-Google-Sender-Auth: CJhPd3T6rLuEpCzoFWsUxlu0XrQ
Message-ID: <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 6:57 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Mon, Sep 19, 2011 at 18:13 +0300, Pekka Enberg wrote:
>> On Mon, Sep 19, 2011 at 5:46 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> >> and
>> >> concluded that it's not worth it doesn't really protect from anything
>> >
>> > Closing only slabinfo doesn't add any significant protection against
>> > kernel heap exploits per se, no objections here.
>> >
>> > But as said in the desciption, the reason for this patch is not protecting
>> > against exploitation heap bugs.  It is a source of infoleaks of kernel
>> > and userspace activity, which should be forbidden to non-root users.
>>
>> Last time we discussed this, the 'extra protection' didn't seem to be
>> significant enough to justify disabling an useful kernel debugging
>> interface by default.
>>
>> What's different about the patch now?
>
> The exploitation you're talking about is an exploitation of kernel heap
> bugs.  Dan's previous "make slabinfo 0400" patch tried to complicate
> attacker's life by hiding information about how many free object are
> left in the slab.  With this information an attacker may compute how he
> should spray the slab to position slab object to increase his chances of
> overwriting specific memory areas - pointers, etc.
>
> I don't speak about how much/whether closing slabinfo complicates this
> task, though.  My idea is orthogonal to the Dan's idea.  I claim that
> with 0444 slabinfo any user may get information about in-system activity
> that he shouldn't learn.  In short, one may learn precisely when other
> user reads directory contents, opens files, how much files there are in
> the specific _private_ directory, how much files _private_ ecryptfs or
> fuse mount point contains, etc.  This breaks user's assumption that
> the number of files in a private directory is a private information.
> There are a bit more thoughts in the patch description.

Yes, I read your patch description and I think it's convincing enough
to warrant a config option but not changing the default.

However, if the encryptfs and infoleaks really are serious enough to
hide /proc/slabinfo, I think you should consider switching over to
kmalloc() instead of kmem_cache_alloc() to make sure nobody can
gain access to the information. Or add a SLAB_ANON flag for
kmem_cache_create() that forces SLUB cache merging to existing
caches.

>> >> and causes harm to developers.
>> >
>> > One note: only to _kernel_ developers.  It means it is a strictly
>> > debugging feature, which shouldn't be enabled in the production systems.
>>
>> It's pretty much _the_ interface for debugging kernel memory leaks in
>> production systems and we ask users for it along with /proc/meminfo
>> when debugging many memory management related issues. When we
>> temporarily dropped /proc/slabinfo with the introduction of SLUB, people
>> complained pretty loudly.
>
> Could you point to the discussion, please?  I cannot find the patch for
> 0400 slabinfo even in the linux-history repository.

We dropped the whole file for SLUB:

http://lwn.net/Articles/263337/

[ I didn't find the original discussion that motivated the above
  patch but it should be somewhere in LKML archives around
  that time. ]

Making it root-only will have pretty much the same kind of
out-of-the-box behavior.

>> I'd be willing to consider this patch if it's a config option that's not enabled
>> by default; otherwise you need to find someone else to merge the patch.
>> You can add some nasty warnings to the Kconfig text to scare the users
>> into enabling it. ;-)
>
> How do you see this CONFIG_ option?  CONFIG_PROCFS_COMPAT_MODES (or _PERMS),
> defaults to Y?  If we find more procfs files with dangerous permissions,
> we may move it under "ifndef CONFIG_PROCFS_COMPAT_PERMS".

I guess CONFIG_RESTRICT_PROCFS type of thing makes most sense
since the problem is not only about SLAB. If you want to make it slab-only
config option, I'm fine with that too.

Please note that you need to restrict sysfs files for SLUB as well.

                         Pekka
