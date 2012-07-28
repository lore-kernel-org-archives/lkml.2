Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2G1K0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 06:26:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2G1K0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 06:26:15 -0400
Date: Sat, 28 Jul 2012 11:26:09 +0100
From: Mel Gorman <mgorman@suse.de>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [ 39/40] cpuset: mm: reduce large amounts of memory barrier
 related damage v3
Message-ID: <20120728102609.GH612@suse.de>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
 <20120726211414.752069185@linuxfoundation.org>
 <20120727150823.GD3033@herton-Z68MA-D2H-B3>
 <20120727152347.GG612@suse.de>
 <20120727190116.GA29646@kroah.com>
 <20120728050230.GA9155@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120728050230.GA9155@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 02:02:31AM -0300, Herton Ronaldo Krzesinski wrote:
> > Thanks, I've merged this with the "original" in the tree, so all should
> > be good now.
> 
> Thanks. I saw what seems another issue now on the patch too, sorry for
> not noticing earlier: this backport is lacking the
> write_seqcount_{begin,end} on set_mems_allowed for the case with
> CONFIG_CPUSETS, like in the original patch:
> 

Not my finest moment :(

Thanks

---8<---
cpuset: mm: reduce large amounts of memory barrier related damage v3 fix

Missing hunk from backport.

Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 8f15695..7a7e5fd 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -113,7 +113,9 @@ static inline bool put_mems_allowed(unsigned int seq)
 static inline void set_mems_allowed(nodemask_t nodemask)
 {
 	task_lock(current);
+	write_seqcount_begin(&current->mems_allowed_seq);
 	current->mems_allowed = nodemask;
+	write_seqcount_end(&current->mems_allowed_seq);
 	task_unlock(current);
 }
 
