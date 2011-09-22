Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1IVHtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:49:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56705 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1IVHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:49:07 -0400
Date: Thu, 22 Sep 2011 15:48:58 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, weiyang@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        Michal Ludvig <mludvig@logix.net.nz>
Subject: [PATCH] Resource: wrong resource window calculation
Message-ID: <20110922074858.GG5085@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <4E5E0A7E.40301@logix.net.nz>
 <CAErSpo70k6UnhvvOMgQQxJ6BHZOwym=-jaPMvOukAaCr-B0+cQ@mail.gmail.com>
 <4E5EFFBD.4050201@logix.net.nz>
 <CAErSpo6bofeiAxeRo_RjXQSnwmcWrdymn0MK8H4_CwqwoeD1jg@mail.gmail.com>
 <4E634814.4050508@logix.net.nz>
 <20110909113409.GE2416@ram-ThinkPad-T61>
 <4E6C05B7.9000904@logix.net.nz>
 <20110913110646.GB2425@ram-ThinkPad-T61>
 <4E6F400A.6090909@logix.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6F400A.6090909@logix.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  	Resource: wrong resource window calculation

__find_resource() incorrectly returns a resource window which overlaps an
existing allocated window. This happens when the parent's resource-window spans
0x00000000 to 0xffffffff and is entirely allocated to all its children
resource-windows.

__find_resource() looks for gaps in resource allocation among the children
resource windows.  When it encounters the last child window it blindly tries
the range next to one allocated to the last child. Since the last child's
window ends at 0xffffffff the calculation overflows, leading the algorithm to
believe that any window in the range 0x0000000 to 0xfffffff is available for
allocation. This leads to a conflicting window allocation.

Michal Ludvig reported this issue seen on his platform. The following patch
fixes the problem and has been verified by Michal. I believe this bug has been
there for ages. It got exposed by git commit
2bbc6942273b5b3097bd265d82227bdd84b351b2
[PATCH] PCI : ability to relocate assigned pci-resources

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 kernel/resource.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 3ff4017..b29b83d 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -419,6 +419,9 @@ static int __find_resource(struct resource *root, struct resource *old,
 		else
 			tmp.end = root->end;
 
+		if (tmp.end < tmp.start)
+			goto next;
+
 		resource_clip(&tmp, constraint->min, constraint->max);
 		arch_remove_reservations(&tmp);
 
@@ -436,8 +439,10 @@ static int __find_resource(struct resource *root, struct resource *old,
 				return 0;
 			}
 		}
-		if (!this)
+
+next:		if (!this || this->end == root->end)
 			break;
+
 		if (this != old)
 			tmp.start = this->end + 1;
 		this = this->sibling;
-- 
1.7.4.1

