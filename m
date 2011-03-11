Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1CKB0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:26:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55827 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1CKB0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:26:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Mar 2011 10:20:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        Justin TerAvest <teravest@google.com>, m-ikeda <m-ikeda@ds.jp.nec.com>,
        jaxboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ryov <ryov@valinux.co.jp>,
        taka <taka@valinux.co.jp>, "righi.andrea" <righi.andrea@gmail.com>,
        guijianfeng <guijianfeng@cn.fujitsu.com>,
        balbir <balbir@linux.vnet.ibm.com>, ctalbott <ctalbott@google.com>,
        nauman <nauman@google.com>, mrubin <mrubin@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] Storing cgroup id in page->private (Was: Re: [RFC] [PATCH
 0/6] Provide cgroup isolation for buffered writes.)
Message-Id: <20110311102012.0901e551.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299793340-sup-9066@think>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
	<20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
	<20110310181529.GF29464@redhat.com>
	<AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
	<20110310191115.GG29464@redhat.com>
	<20110310194106.GH29464@redhat.com>
	<1299791640-sup-1874@think>
	<3EC7D30A-B8F7-416B-8B1D-A19350C57D82@dilger.ca>
	<20110310213832.GK29464@redhat.com>
	<1299793340-sup-9066@think>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 16:43:31 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> Excerpts from Vivek Goyal's message of 2011-03-10 16:38:32 -0500:
> > On Thu, Mar 10, 2011 at 02:24:07PM -0700, Andreas Dilger wrote:
> > > On 2011-03-10, at 2:15 PM, Chris Mason wrote:
> > > > Excerpts from Vivek Goyal's message of 2011-03-10 14:41:06 -0500:
> > > >> On Thu, Mar 10, 2011 at 02:11:15PM -0500, Vivek Goyal wrote:
> > > >>>>> I think the person who dirtied the page can store the information in
> > > >>>>> page->private (assuming buffer heads were not generated) and if flusher
> > > >>>>> thread later ends up generating buffer heads and ends up modifying
> > > >>>>> page->private, this can be copied in buffer heads?
> > > >>>> 
> > > >>>> This scares me a bit.
> > > >>>> 
> > > >>>> As I understand it, fs/ code expects total ownership of page->private.
> > > >>>> This adds a responsibility for every user to copy the data through and
> > > >>>> store it in the buffer head (or anything else). btrfs seems to do
> > > >>>> something entirely different in some cases and store a different kind
> > > >>>> of value.
> > > >>> 
> > > >>> If filesystems are using page->private for some other purpose also, then
> > > >>> I guess we have issues. 
> > > >>> 
> > > >>> I am ccing linux-fsdevel to have some feedback on the idea of trying
> > > >>> to store cgroup id of page dirtying thread in page->private and/or buffer
> > > >>> head for tracking which group originally dirtied the page in IO controller
> > > >>> during writeback.
> > > >> 
> > > >> A quick "grep" showed that btrfs, ceph and logfs are using page->private
> > > >> for other purposes also.
> > > >> 
> > > >> I was under the impression that either page->private is null or it 
> > > >> points to buffer heads for the writeback case. So storing the info
> > > >> directly in either buffer head directly or first in page->private and
> > > >> then transferring it to buffer heads would have helped. 
> > > > 
> > > > Right, btrfs has its own uses for page->private, and we expect to own
> > > > it.  With a proper callback, the FS could store the extra information you
> > > > need in out own structs.
> > > 
> > > There is no requirement that page->private ever points to a buffer_head, and Lustre clients use it for its own tracking structure (never touching buffer_heads at all).  Any assumption about what a filesystem is storing in page->private in other parts of the code is just broken.
> > 
> > Andreas,
> > 
> > As Chris mentioned, will providing callbacks so that filesystem can
> > save/restore page->private be reasonable?
> 
> Just to clarify, I think saving/restoring page->private is going to be
> hard.  I'd rather just have a call back that says here's a page, storage
> this for the block io controller please, and another one that returns
> any previously stored info.
> 

Hmm, Vivek,
for dynamic allocation of io-record, how about this kind of tagging ?
(just an idea. not compiled at all.)

Pros.
- much better than consuming 2bytes for all pages including pages other 
  than file caches. 
- this will allow lockless lookup of iotag.
- setting iotag can be done at the same time PAGECACHE_TAG_DIRTY...
  no extra lock will be required.
- At clearing, we can expect lock for radix-tree is already held.
Cons.
- makes radix-tree struct larger and not good for cacheline.
- some special care? will be required at page-migration.


==
@@ -51,6 +51,9 @@ struct radix_tree_node {
        struct rcu_head rcu_head;
        void __rcu      *slots[RADIX_TREE_MAP_SIZE];
        unsigned long   tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
+#ifdef CONFIG_BLK_CGROUP
+       unsigned short  iotag[RADIX_TREE_MAP_SIZE];
+#endif
 };

 struct radix_tree_path {
@@ -487,6 +490,36 @@ void *radix_tree_tag_set(struct radix_tr
 }
 EXPORT_SYMBOL(radix_tree_tag_set);

+#ifdef CONFIG_BLK_CGROUP
+void *radix_tree_iotag_set(struct radix_tree_root *root,
+                       unsigned long index, unsigned short tag)
+{
+       unsigned int height, shift;
+       struct radix_tree_node *node;
+
+       height = root->height;
+       BUG_ON(index > radix_tree_maxindex(height));
+
+       node = indirect_to_ptr(root->rnode);
+       shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+
+       while (height > 0) {
+               int offset;
+
+               offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+               node = node->slots[offset];
+               BUG(!node);
+               shift -= RADIX_TREE_MAP_SHIFT;
+               height--;
+       }
+       node->iotag[offset] = tag;
+
+       return;
+}
+EXPORT_SYMBOL(radix_tree_iotag_set);
+

