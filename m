Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1GCVa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:30:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756639Ab1GCVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jul 2011 14:30:00 -0700
Message-ID: <CA+55aFwo-48yKu+raRF3B9n1mqd1qV35eDq56Yi+erPygkuTvA@mail.gmail.com>
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
To: Ram Pai <linuxram@us.ibm.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaah. I'm still rather uncomfortable about this, and I wonder about
patch 2 in particular. It seems that that patch could/should be split
up: the whole change to "find_resource()" etc looks like prime
material for a separate patch that splits up that function and
explains why that change is done.

Also, quite frankly, by the time you pass in eight different arguments
(and pretty complex ones at that, with one being the alignment
function pointer), I start thinking that you should have passed in a
pointer to a descriptor structure instead. I get the feeling that the
"resource requirements" really should be a structure instead of lots
of individual arguments:

IOW, this part:

+                     resource_size_t newsize, resource_size_t min,
+                     resource_size_t max, resource_size_t align,
+                     resource_size_t (*alignf)(void *,
+                                               const struct resource *,
+                                               resource_size_t,
+                                               resource_size_t),
+                     void *alignf_data)

really makes me go

   struct resource_requirement {
      resource_size_t min, max, align;
      resource_size_t (*alignf)(const struct resource *, struct
resource_requirement *);
      void *alignf_data);
   };

and I'd really change the function argument to take that kind of
simplified thing instead.

And that cleanup/re-organization would be prime material for a totally
independent patch that changes no semantics at all, just prepares for
the other changes.

That way the final "patch 2" would be smaller and do the semantic
changes, instead of being a mix of semantic changes and infrastructure
changes.

And some of the cleanup stuff I could merge for 3.0 just to make things easier.

Hmm?

                 Linus
