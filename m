Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1EPSs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:48:26 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37778 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1EPSsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:48:24 -0400
Subject: Re: [PATCH v5 13/21] evm: add evm_inode_post_init call in gfs2
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        linux-security-module@vger.kernl.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>
In-Reply-To: <4DD16B96.7020907@schaufler-ca.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-14-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305559822.2855.14.camel@menhir>
	 <1305561051.2669.10.camel@localhost.localdomain>
	 <1305562469.2855.26.camel@menhir>
	 <1305563758.2669.26.camel@localhost.localdomain>
	 <1305568250.2669.47.camel@localhost.localdomain>
	 <1305568671.2855.31.camel@menhir>  <4DD16B96.7020907@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 14:48:03 -0400
Message-ID: <1305571683.2669.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 11:23 -0700, Casey Schaufler wrote:
> On 5/16/2011 10:57 AM, Steven Whitehouse wrote:
> > Hi,
> >
> > On Mon, 2011-05-16 at 13:50 -0400, Mimi Zohar wrote:
> >> On Mon, 2011-05-16 at 12:35 -0400, Mimi Zohar wrote:
> >>> On Mon, 2011-05-16 at 17:14 +0100, Steven Whitehouse wrote:
> >>>> Hi,
> >>>>
> >>>> On Mon, 2011-05-16 at 11:50 -0400, Mimi Zohar wrote:
> >>>>> On Mon, 2011-05-16 at 16:30 +0100, Steven Whitehouse wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> On Mon, 2011-05-16 at 10:45 -0400, Mimi Zohar wrote:
> >>>>>>> After creating the initial LSM security extended attribute, call
> >>>>>>> evm_inode_post_init_security() to create the 'security.evm'
> >>>>>>> extended attribute.
> >>>>>>>
> >>>>>>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> >>>>>>> ---
> >>>>>>>  fs/gfs2/inode.c |   28 +++++++++++++++++++---------
> >>>>>>>  1 files changed, 19 insertions(+), 9 deletions(-)
> >>>>>>>
> >>>>>> [snip]
> >>>>>>> +	struct xattr lsm_xattr;
> >>>>>>> +	struct xattr evm_xattr;
> >>>>>>>  
> >>>>>>>  	err = security_inode_init_security(&ip->i_inode, &dip->i_inode, qstr,
> >>>>>>> -					   &name, &value, &len);
> >>>>>>> +					   &lsm_xattr.name, &lsm_xattr.value,
> >>>>>>> +					   &lsm_xattr.value_len);
> >>>>>>>  
> >>>>>>>  	if (err) {
> >>>>>>>  		if (err == -EOPNOTSUPP)
> >>>>>>> @@ -780,11 +781,20 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
> >>>>>>>  		return err;
> >>>>>>>  	}
> >>>>>>>  
> >>>>>>> -	err = __gfs2_xattr_set(&ip->i_inode, name, value, len, 0,
> >>>>>>> -			       GFS2_EATYPE_SECURITY);
> >>>>>>> -	kfree(value);
> >>>>>>> -	kfree(name);
> >>>>>>> -
> >>>>>>> +	err = __gfs2_xattr_set(&ip->i_inode, lsm_xattr.name, lsm_xattr.value,
> >>>>>>> +			       lsm_xattr.value_len, 0, GFS2_EATYPE_SECURITY);
> >>>>>>> +	if (err < 0)
> >>>>>>> +		goto out;
> >>>>>>> +	err = evm_inode_post_init_security(&ip->i_inode, &lsm_xattr,
> >>>>>>> +					   &evm_xattr);
> >>>>>>> +	if (err)
> >>>>>>> +		goto out;
> >>>>>>> +	err = __gfs2_xattr_set(&ip->i_inode, evm_xattr.name, evm_xattr.value,
> >>>>>>> +			       evm_xattr.value_len, 0, GFS2_EATYPE_SECURITY);
> >>>>>>> +	kfree(evm_xattr.value);
> >>>>>>> +out:
> >>>>>>> +	kfree(lsm_xattr.name);
> >>>>>>> +	kfree(lsm_xattr.value);
> >>>>>>>  	return err;
> >>>>>>>  }
> >>>>>>>  
> >>>>>> Just wondering whether we could have a single call to the security
> >>>>>> subsystem which returns a vector of xattrs rather than having to call
> >>>>>> two different functions?
> >>>>>>
> >>>>>> Steve.
> >>>>> There are a number of places that the LSM function is called immediately
> >>>>> followed by either EVM/IMA.  In each of those places it is hidden from
> >>>>> the caller by calling the security_inode_XXX_security().  In this case
> >>>>> each fs has it's own method of creating an extended attribute.  If that
> >>>>> method could be passed to security_inode_init_security, then
> >>>>> security_inode_init_security() could call both the LSM and EVM functions
> >>>>> directly.
> >>>>>
> >>>>> Mimi
> >>>>>
> >>>> I'm still not quite sure I understand... from a (very brief) look at the
> >>>> paper, it seems that what you are trying to do is add a new xattr to
> >>>> inodes which has some hash of some of the inode metadata (presumably
> >>>> including the selinux xattr and some other fields).
> >>> Yes, for the time being the other metadata is i_ino, i_generation,
> >>> i_uid, i_gid, and i_mode.  The IMA-appriasal extension would store the
> >>> file hash as an extended attribute. The digital-signature extension
> >>> would store a digitial signature instead of the hash.
> >>>
> >>>> I'm not sure why it matters whether the selinux data has been written to
> >>>> the buffers before the xattr containing the hash? The data will not
> >>>> change (I hope!) and if it does presumably the hash will pick that up
> >>>> when it is checked at a later date?
> >>> In this case it doesn't matter, as there aren't any other xattrs at this
> >>> point.  When the file closes, the file hash would be written out as
> >>> security.ima, causing security.evm to be updated to reflect the change.
> >>>
> >>>> The reason I'm asking is that currently the creation of GFS2 inodes is
> >>>> broken down into a number of transactions, carefully designed to ensure
> >>>> that the correct clean up occurs if there is an error. I would like to
> >>>> try and reduce the number of transactions during the create process
> >>>> where possible. That means I would like to move to a model which looks
> >>>> like this:
> >>>>
> >>>> 1. Calculate number of blocks required, based on inode + xattrs (if any)
> >>>> 2. Allocate blocks
> >>>> 3. Populate with data (i.e. set xattrs)
> >>>>
> >>>> I'm trying to work out whether there is some reason why we have to use
> >>>> your proposed:
> >>>>
> >>>> 1. Get selinux xattr
> >>>> 2. Set selinux xattr
> >>>> 3. Get EVM xattr
> >>>> 4. Set EVM xattr
> >>>>
> >>>> as opposed to getting all the xattrs in a single call and then being
> >>>> able to set them all in a single operation, if that makes sense?
> >>>>
> >>>> Steve.
> >>> Yes, it makes sense.
> >> Just to clarify (and am cc'ing Stephen, Eric, and Casey).
> >>
> >> Instead of:
> >>
> >> int security_inode_init_security(struct inode *inode, struct inode *dir,
> >>                                  const struct qstr *qstr, char **name,
> >>                                  void **value, size_t *len);
> >>
> >> You're suggesting changing the interface to something like:
> >>
> >> int security_inode_init_security(struct inode *inode, struct inode *dir,
> >>                                  const struct qstr *qstr, struct xattr **xattrs);
> >>
> >> where 'struct xattr' is defined as (9th patch):
> >>
> >> --- a/include/linux/xattr.h
> >> +++ b/include/linux/xattr.h
> >> @@ -70,6 +70,12 @@ struct xattr_handler {
> >>                    size_t size, int flags, int handler_flags);
> >>  };
> >>
> >> +struct xattr {
> >> +       char *name;
> >> +       void *value;
> >> +       size_t value_len;
> >> +};
> >> +
> >>  ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
> >>  ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
> >>  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> >>
> >> xattrs would be null terminated. The fs would be responsible for freeing the xattrs?
> >>
> >> thanks,
> >>
> >> Mimi
> >>
> > Yes, if that makes sense... I got the impression from the paper that
> > there is the possibility of more xattrs being added in future and this
> > way the fs end of things wouldn't have to change again when that
> > happens. I'm still trying to get my head around it all, but it seems a
> > cleaner solution to me - though I may well be missing something still,
> 
> There is a very real possibility that multiple concurrent LSMs will
> be supported before too long. Smack already uses multiple attributes
> (SMACK64, SMACK64EXEC) on a file. Getting all the attributes in a
> single call could result in an interface that requires parsing a
> string argument, and we all know how popular those are. Introducing
> an interface that we know isn't going to accommodate this upcoming
> direction does not seem prudent.

I would think that Smack would benefit from Steven's suggestion of
returning an array of xattrs. Without his suggestion, I'm not sure how
you are, or planning on, initializing multiple xattrs from a single LSM,
unless of course you're not using security_inode_init_security().

Multiple LSMs calling security_inode_init_security() will be an issue
for EVM, as EVM assumes there is a single LSM xattr on which to base the
initial hmac.

thanks,

Mimi

