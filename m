Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab1EBOKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759090Ab1EBOKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:10:05 -0400
Date: Mon, 2 May 2011 17:10:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110502141002.GK18376@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
 <20110429083618.GL2191@linux.vnet.ibm.com>
 <20110429083904.GA12987@linux.vnet.ibm.com>
 <20110429180239.GA32566@redhat.com>
 <20110430125928.GJ2297@linux.vnet.ibm.com>
 <20110502105612.GJ18376@redhat.com>
 <20110502133608.GA4197@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502133608.GA4197@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 06:36:08AM -0700, Paul E. McKenney wrote:
> On Mon, May 02, 2011 at 01:56:12PM +0300, Gleb Natapov wrote:
> > On Sat, Apr 30, 2011 at 05:59:28AM -0700, Paul E. McKenney wrote:
> > > On Fri, Apr 29, 2011 at 09:02:39PM +0300, Gleb Natapov wrote:
> > > > On Fri, Apr 29, 2011 at 01:39:04AM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Apr 29, 2011 at 01:36:18AM -0700, Paul E. McKenney wrote:
> > > > > > On Thu, Apr 28, 2011 at 12:52:02PM +0300, Gleb Natapov wrote:
> > > > > > 
> > > > > > Hmmm....  This is interesting.  KVM being a module, we either expand
> > > > > > TINY_RCU's size a bit by making rcu_note_context_switch() be a real
> > > > > > function in rcutiny.c and adding an export, or we expand it by adding
> > > > > > two exports.
> > > > > > 
> > > > > > I would like to solve this without making TINY_RCU larger, and preferably
> > > > > > by making it smaller.  Any ideas come to mind?  (Other than making
> > > > > > KVM depend on CONFIG_SMP, which sounds too much like throwing out the
> > > > > > baby with the bathwater.)
> > > > > 
> > > > > Nothing quite like hitting "send" to make an idea show up...
> > > > > 
> > > > > In a UP kernel, does it actually help anything to have KVM
> > > > > tell RCU about executing in a guest?  If not, could we have a
> > > > > rcu_note_context_switch_kvm() that is a static inline empty function in
> > > > > TINY_RCU and maps to rcu_note_context_switch() for TREE_RCU?
> > > > > 
> > > > That will work, but does making rcu_note_context_switch() out of line
> > > > actually increase kernel size? The function is called in two places
> > > > currently, so by making it out of line we make two calling site smaller.
> > > > Will measure it next week.
> > > 
> > > One thing to keep in mind...  Calling an out-of-line function from
> > > KVM requires an export, each of which significantly increases TINY_RCU's
> > > memory footprint.
> > > 
> > > 							Thanx, Paul
> > > 
> > How significantly? As I wrote in other mail I compiled two TINY_RCU
> > kernel with and without the patch and I didn't see memory footprint
> > increase at all. May be I measure it incorrectly, but what I see is that
> > with out of line function + export text section becomes 64 byte bigger, but
> > data section becomes 64 byte smaller:
> > 
> >    text    data     bss     dec     hex filename
> > 4544134  590596 2023424 7158154  6d398a vmlinux     inline
> > 4544198  590532 2023424 7158154  6d398a vmlinux.ol  out of line
> 
> Did you add the exports that would be needed to allow KVM to call
> the functions in the inline case?
> 
Yes, this is with and without patch applied. When patch is applied the
function is out of line and exported.

--
			Gleb.
