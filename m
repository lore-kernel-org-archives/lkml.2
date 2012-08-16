Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab2HPVkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:40:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab2HPVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:40:07 -0400
Date: Thu, 16 Aug 2012 16:39:51 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 1/7] integrity: added digest calculation function
Message-ID: <20120816213951.GC18485@sergelap>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
 <f5c7c0f9ef113263bf17c39e9b7927f085872107.1345055639.git.dmitry.kasatkin@intel.com>
 <20120815201135.GA10088@amd1>
 <CALLzPKaczBwsj0s5wxTLaZ2_=J_fCdbP2SB0R2oUxMyHLDRYMg@mail.gmail.com>
 <CALLzPKZs79M_s9-ESyMfQudUikEW8GZbggEedfBsp-6L6gxyZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZs79M_s9-ESyMfQudUikEW8GZbggEedfBsp-6L6gxyZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kasatkin, Dmitry (dmitry.kasatkin@intel.com):
> On Thu, Aug 16, 2012 at 12:11 AM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
> > On Wed, Aug 15, 2012 at 11:11 PM, Serge Hallyn
> > <serge.hallyn@canonical.com> wrote:
> >> Quoting Dmitry Kasatkin (dmitry.kasatkin@intel.com):
> >>> There are several functions, that need to calculate digest.
> >>> This patch adds common function for use by integrity subsystem.
> >>>
> >>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> >>> ---
> >>>  security/integrity/digsig.c    |   31 +++++++++++++++++++++++++++++--
> >>>  security/integrity/integrity.h |    3 +++
> >>>  2 files changed, 32 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> >>> index 2dc167d..61a0c92 100644
> >>> --- a/security/integrity/digsig.c
> >>> +++ b/security/integrity/digsig.c
> >>> @@ -13,9 +13,9 @@
> >>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >>>
> >>>  #include <linux/err.h>
> >>> -#include <linux/rbtree.h>
> >>>  #include <linux/key-type.h>
> >>>  #include <linux/digsig.h>
> >>> +#include <crypto/hash.h>
> >>>
> >>>  #include "integrity.h"
> >>>
> >>> @@ -28,7 +28,7 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
> >>>  };
> >>>
> >>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> >>> -                                     const char *digest, int digestlen)
> >>> +                         const char *digest, int digestlen)
> >>>  {
> >>>       if (id >= INTEGRITY_KEYRING_MAX)
> >>>               return -EINVAL;
> >>> @@ -46,3 +46,30 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> >>>
> >>>       return digsig_verify(keyring[id], sig, siglen, digest, digestlen);
> >>>  }
> >>> +
> >>> +int integrity_calc_digest(const char *algo, const void *data, const int len,
> >>> +                       char *digest)
> >>> +{
> >>> +     int rc = -ENOMEM;
> >>> +     struct crypto_shash *tfm;
> >>> +
> >>> +     tfm = crypto_alloc_shash(algo, 0, 0);
> >>> +     if (IS_ERR(tfm)) {
> >>> +             rc = PTR_ERR(tfm);
> >>> +             pr_err("Can not allocate %s (reason: %d)\n", algo, rc);
> >>> +             return rc;
> >>> +     } else {
> >>> +             struct {
> >>> +                     struct shash_desc shash;
> >>> +                     char ctx[crypto_shash_descsize(tfm)];
> >>> +             } desc;
> >>
> >> Needless confusing indentation here.  Just move the struct {} desc; to the
> >> top and drop the else.  That will make it much more readable.
> >>
> >
> > Intention was to allocate it only if tfm allocation succeeded..
> > But indeed failure very unlikely..
> >
> 
> BTW.. The reason for such code is that ctx member uses function in the
> parameter:
> 
> char ctx[crypto_shash_descsize(tfm)];
> 
> It is not possible to do it before tfm allocation...
> So I cannot move it up..

Ah, I see.  Cool :)

> I can only kmalloc it then.

Well no, you could use another function I suppose.

But if you're going to leave it as is, please at least move the whole
rest of the function into the else{} :)  Yes, no functional change,
but a change in how it looks to the eye of someone trying to review
and look for actual free-unallocated-memory errors or leaks.

-serge
