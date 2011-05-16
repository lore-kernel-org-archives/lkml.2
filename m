Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1EPPvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:51:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35632 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1EPPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:51:10 -0400
Subject: Re: [PATCH v5 13/21] evm: add evm_inode_post_init call in gfs2
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-security-module@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1305559822.2855.14.camel@menhir>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-14-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305559822.2855.14.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 11:50:51 -0400
Message-ID: <1305561051.2669.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 16:30 +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Mon, 2011-05-16 at 10:45 -0400, Mimi Zohar wrote:
> > After creating the initial LSM security extended attribute, call
> > evm_inode_post_init_security() to create the 'security.evm'
> > extended attribute.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> >  fs/gfs2/inode.c |   28 +++++++++++++++++++---------
> >  1 files changed, 19 insertions(+), 9 deletions(-)
> > 
> [snip]
> > +	struct xattr lsm_xattr;
> > +	struct xattr evm_xattr;
> >  
> >  	err = security_inode_init_security(&ip->i_inode, &dip->i_inode, qstr,
> > -					   &name, &value, &len);
> > +					   &lsm_xattr.name, &lsm_xattr.value,
> > +					   &lsm_xattr.value_len);
> >  
> >  	if (err) {
> >  		if (err == -EOPNOTSUPP)
> > @@ -780,11 +781,20 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
> >  		return err;
> >  	}
> >  
> > -	err = __gfs2_xattr_set(&ip->i_inode, name, value, len, 0,
> > -			       GFS2_EATYPE_SECURITY);
> > -	kfree(value);
> > -	kfree(name);
> > -
> > +	err = __gfs2_xattr_set(&ip->i_inode, lsm_xattr.name, lsm_xattr.value,
> > +			       lsm_xattr.value_len, 0, GFS2_EATYPE_SECURITY);
> > +	if (err < 0)
> > +		goto out;
> > +	err = evm_inode_post_init_security(&ip->i_inode, &lsm_xattr,
> > +					   &evm_xattr);
> > +	if (err)
> > +		goto out;
> > +	err = __gfs2_xattr_set(&ip->i_inode, evm_xattr.name, evm_xattr.value,
> > +			       evm_xattr.value_len, 0, GFS2_EATYPE_SECURITY);
> > +	kfree(evm_xattr.value);
> > +out:
> > +	kfree(lsm_xattr.name);
> > +	kfree(lsm_xattr.value);
> >  	return err;
> >  }
> >  
> 
> Just wondering whether we could have a single call to the security
> subsystem which returns a vector of xattrs rather than having to call
> two different functions?
> 
> Steve.

There are a number of places that the LSM function is called immediately
followed by either EVM/IMA.  In each of those places it is hidden from
the caller by calling the security_inode_XXX_security().  In this case
each fs has it's own method of creating an extended attribute.  If that
method could be passed to security_inode_init_security, then
security_inode_init_security() could call both the LSM and EVM functions
directly.

Mimi

