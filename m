Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1FCMcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:32:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45680 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab1FCMcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:32:02 -0400
Subject: Re: [PATCH v6 04/20] evm: add support for different security.evm
 data types
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20110602225005.GB23700@mail.hallyn.com>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1307017423-15093-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110602225005.GB23700@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 08:31:56 -0400
Message-ID: <1307104316.3137.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 17:50 -0500, Serge E. Hallyn wrote:
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> > 
> > EVM protects a file's security extended attributes(xattrs) against integrity
> > attacks. The current patchset maintains an HMAC-sha1 value across the security
> > xattrs, storing the value as the extended attribute 'security.evm'. We
> > anticipate other methods for protecting the security extended attributes.
> > This patch reserves the first byte of 'security.evm' as a place holder for
> > the type of method.
> > 
> > Changelog v6:
> > - move evm_ima_xattr_type definition to security/integrity/integrity.h
> > - defined a structure for the EVM xattr called evm_ima_xattr_data
> >   (based on Serge Hallyn's suggestion)
> > 
> > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> >  include/linux/integrity.h           |    1 +
> >  security/integrity/evm/evm_crypto.c |   11 +++++++----
> >  security/integrity/evm/evm_main.c   |   10 +++++-----
> >  security/integrity/integrity.h      |   11 +++++++++++
> >  4 files changed, 24 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/linux/integrity.h b/include/linux/integrity.h
> > index e715a2a..9684433 100644
> > --- a/include/linux/integrity.h
> > +++ b/include/linux/integrity.h
> > @@ -19,6 +19,7 @@ enum integrity_status {
> >  	INTEGRITY_UNKNOWN,
> >  };
> >  
> > +/* List of EVM protected security xattrs */
> >  #ifdef CONFIG_INTEGRITY
> >  extern int integrity_inode_alloc(struct inode *inode);
> >  extern void integrity_inode_free(struct inode *inode);
> > diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> > index d49bb00..c631b99 100644
> > --- a/security/integrity/evm/evm_crypto.c
> > +++ b/security/integrity/evm/evm_crypto.c
> > @@ -141,14 +141,17 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
> >  			const char *xattr_value, size_t xattr_value_len)
> >  {
> >  	struct inode *inode = dentry->d_inode;
> > -	u8 hmac[SHA1_DIGEST_SIZE];
> > +	struct evm_ima_xattr_data xattr_data;
> >  	int rc = 0;
> >  
> >  	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
> > -			   xattr_value_len, hmac);
> > -	if (rc == 0)
> > +			   xattr_value_len, xattr_data.digest);
> > +	if (rc == 0) {
> > +		xattr_data.type = EVM_XATTR_HMAC;
> >  		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
> > -					   hmac, SHA1_DIGEST_SIZE, 0);
> > +					   &xattr_data,
> > +					   sizeof(xattr_data), 0);
> > +	}
> >  	else if (rc == -ENODATA)
> >  		rc = inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
> >  	return rc;
> > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > index a8fa45f..c0580dd1 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -51,20 +51,20 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  					     size_t xattr_value_len,
> >  					     struct integrity_iint_cache *iint)
> >  {
> > -	char hmac_val[SHA1_DIGEST_SIZE];
> > +	struct evm_ima_xattr_data xattr_data;
> >  	int rc;
> >  
> >  	if (iint->hmac_status != INTEGRITY_UNKNOWN)
> >  		return iint->hmac_status;
> >  
> > -	memset(hmac_val, 0, sizeof hmac_val);
> 
> Why did you drop the memset here?
> 
> (You didn't in the previous version of this patch)

Based on a discussion with Dmitry, neither the crypto nor the logic need
it initialized. Forgot to add it to the changelog.  :-(

> Otherwise, looks good.
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Thanks!

> >  	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
> > -			   xattr_value_len, hmac_val);
> > +			   xattr_value_len, xattr_data.digest);
> >  	if (rc < 0)
> >  		return INTEGRITY_UNKNOWN;
> >  
> > -	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, hmac_val, sizeof hmac_val,
> > -			   GFP_NOFS);
> > +	xattr_data.type = EVM_XATTR_HMAC;
> > +	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, (u8 *)&xattr_data,
> > +			   sizeof xattr_data, GFP_NOFS);
> >  	if (rc < 0)
> >  		goto err_out;
> >  	iint->hmac_status = INTEGRITY_PASS;
> > diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> > index 397a46b..7efbf56 100644
> > --- a/security/integrity/integrity.h
> > +++ b/security/integrity/integrity.h
> > @@ -18,6 +18,17 @@
> >  /* iint cache flags */
> >  #define IMA_MEASURED		0x01
> >  
> > +enum evm_ima_xattr_type {
> > +	IMA_XATTR_DIGEST = 0x01,
> > +	EVM_XATTR_HMAC,
> > +	EVM_IMA_XATTR_DIGSIG,
> > +};
> > +
> > +struct evm_ima_xattr_data {
> > +	u8 type;
> > +	u8 digest[SHA1_DIGEST_SIZE];
> > +}  __attribute__((packed));
> > +
> >  /* integrity data associated with an inode */
> >  struct integrity_iint_cache {
> >  	struct rb_node rb_node; /* rooted in integrity_iint_tree */
> > -- 
> > 1.7.3.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


