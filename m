Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1AUP2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:28:13 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:55317 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753982Ab1AUP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:28:11 -0500
Subject: Re: [PATCH 1/3] selinux: return -ENOMEM when memory allocation
 fails
From: Davidlohr Bueso <dave@gnu.org>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        LKML <linux-kernel@vger.kernel.org>, selinux@tycho.nsa.gov
In-Reply-To: <alpine.LRH.2.00.1101211101150.14355@tundra.namei.org>
References: <1295548318.2089.11.camel@offworld>
	 <alpine.LRH.2.00.1101211101150.14355@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 12:28:04 -0300
Message-ID: <1295623684.1984.2.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 11:07 +1100, James Morris wrote:
> On Thu, 20 Jan 2011, Davidlohr Bueso wrote:
> 
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  security/selinux/ss/conditional.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
> > index c3f845c..a533732 100644
> > --- a/security/selinux/ss/conditional.c
> > +++ b/security/selinux/ss/conditional.c
> > @@ -178,7 +178,7 @@ int cond_init_bool_indexes(struct policydb *p)
> >  	p->bool_val_to_struct = (struct cond_bool_datum **)
> >  		kmalloc(p->p_bools.nprim * sizeof(struct cond_bool_datum *), GFP_KERNEL);
> >  	if (!p->bool_val_to_struct)
> > -		return -1;
> > +		return -ENOMEM;
> >  	return 0;
> 
> The caller has already set -ENOMEM, so the code should probably be updated 
> there, too, e.g.
> 
> 	rc = cond_init_bool_indexes();
> 	if (rc)
> 		goto out;

Ah yes, thanks for pointing this out.

From: Davidlohr Bueso <dave@gnu.org>
Date: Fri, 21 Jan 2011 12:26:51 -0300
Subject: [PATCH] selinux: return -ENOMEM when memory allocation fails

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 security/selinux/ss/conditional.c |    2 +-
 security/selinux/ss/policydb.c    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index c3f845c..a533732 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -178,7 +178,7 @@ int cond_init_bool_indexes(struct policydb *p)
 	p->bool_val_to_struct = (struct cond_bool_datum **)
 		kmalloc(p->p_bools.nprim * sizeof(struct cond_bool_datum *), GFP_KERNEL);
 	if (!p->bool_val_to_struct)
-		return -1;
+		return -ENOMEM;
 	return 0;
 }
 
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index be9de38..0ebf5b5 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -500,9 +500,9 @@ static int policydb_index(struct policydb *p)
 				 p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto out;
-
-	rc = -ENOMEM;
-	if (cond_init_bool_indexes(p))
+	
+	rc = cond_init_bool_indexes(p);
+	if (rc)
 		goto out;
 
 	for (i = 0; i < SYM_NUM; i++) {
-- 
1.7.1




