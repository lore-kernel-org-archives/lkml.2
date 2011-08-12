Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1HLTQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:16:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37632 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1HLTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:16:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=KfSig92Mt2CtQbRU6nFx1Vbt7rQSkWQxjeUmWohvHJ4aZwPkhMVQB8ijUCvwoYmyW
	JDuhROVnrKtOmjJRf9idg==
Date: Fri, 12 Aug 2011 12:15:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: David Gibson <david@gibson.dropbear.id.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>, qemu-devel@nongnu.org, agraf@suse.de,
        kvm <kvm@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Hastings <abh@cray.com>,
        Adam Litke <agl@us.ibm.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Fix refcounting in hugetlbfs quota handling
In-Reply-To: <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1108121126560.1290@sister.anvils>
References: <20110811064059.GU6342@yookeroo.fritz.box> <CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com> <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-278926984-1313176534=:1290"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-278926984-1313176534=:1290
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 12 Aug 2011, Minchan Kim wrote:
> On Fri, Aug 12, 2011 at 9:48 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Aug 10, 2011 at 11:40 PM, David Gibson
> > <david@gibson.dropbear.id.au> wrote:
> >>
> >> This patch, therefore, stores a pointer to the inode instead of the
> >> address_space in the page private data for hugepages. =C2=A0More
> >> importantly it correctly adjusts the reference count on the inodes
> >> when they're added to the page private data. =C2=A0This ensures that t=
he
> >> inode (and therefore the super block) will not be freed before we use
> >> it from free_huge_page.
> >
> > Looks sane, but I *really* want some acks from people who use/know
> > hugetlbfs. Who would that be? I'm adding random people who have
> > acked/signed-off patches to hugetlbfs recently..
>=20
> At least, code itself looks good to me but your random choice was failed.
> Maybe people you want are as follows.
> http://marc.info/?t=3D126928975800003&r=3D1&w=3D2
>=20
> Ccing right persons.

I don't know much about hugetlbfs these days, but I think the patch
is very wrong.

The real change is where alloc_huge_page() does igrab(inode) and
free_huge_pages() does iput(inode)?

That makes me very nervous, partly because a final iput() is a complex
operation, which we wouldn't expect to be doing when "freeing" a page.

My first worry was that free_huge_page() could actually get called at
interrupt time (when it's in a pagevec of pages to be freed as a batch,
then another put_page is done at interrupt time which frees that batch):
I worried that we use spin_lock not spin_lock_irqsave on inode->i_lock.
To be honest though, I've not followed up whether that's actually a
possibility, the compound page path is too twisty for a quick answer;
and even if it's a possibility, it's one that's already ignored in the
case of hugetlb_lock.

Setting that aside, I think this thing of grabbing a reference to inode
for each page just does not work as you wish: when we unlink an inode,
all its pages should be freed; but because they are themselves holding
references to the inode, it and its pages stick around forever.

A quick experiment with your patch versus without confirmed that:
meminfo HugePages_Free stayed down with your patch, but went back to
HugePages_Total without it.  Please check, perhaps I'm just mistaken.

Sorry, I've not looked into what a constructive alternative might be;
and it's not the first time we've had this difficulty - it came up last
year when the ->freepage function was added, that the inode may be gone
by the time ->freepage(page) is called.

On a side note, very good description - thank you, but I wish you'd
split the patch into two, the fix and then the inode-instead-of-mapping
cleanup.  Though personally I'd prefer not to make that "cleanup": it's
normal for a struct address space * to be used in struct page (if I delved
I guess I'd find good reason why this one is in page->private instead of
page->mapping: perhaps because it's needed after page->mapping is reset
to NULL, perhaps because it's needed on COWed copies of hugetlbfs pages).

Hugh
--8323584-278926984-1313176534=:1290--
