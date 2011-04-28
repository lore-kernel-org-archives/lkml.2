Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1D1JYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:24:38 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46949 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab1D1JYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:24:35 -0400
X-Sasl-enc: H29pnb8AMyjxTtJvwRXFJniy8fyVFQMFZg7kHtJnvWB1 1303982674
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 4/7] smack: fix label check in smack_kernel_act_as()
Date: Thu, 28 Apr 2011 11:22:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.2; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <1303907657-18366-5-git-send-email-roberto.sassu@polito.it> <4DB8A53A.4010709@schaufler-ca.com>
In-Reply-To: <4DB8A53A.4010709@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281122.31702.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 28, 2011 01:22:34 AM Casey Schaufler wrote:
> On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> > The function smack_kernel_act_as() must return -EINVAL if the label
> > returned by smack_from_secid() is equal to 'smack_known_invalid.smk_known',
> > which means that no entries in the 'smack_known_list' list matching the
> > security identifier given are found.
> 
> I'll admit that the code here is wrong, but I disagree with the fix.
> 
> smack_from_secid() will never return NULL, so the check for NULL is
> pointless. Checking for known_invalid is not right either, as the
> Smack philosophy is to return a label in all cases, as is evident
> by the behavior of smack_from_secid(). Thus, the correct change
> would be to remove the error check completely and set the new task
> value to the value obtained from smack_from_secid in all cases.
> 
> Besides, where did the caller of this function get a secid that isn't
> going to map to a Smack label?
> 

I discovered the issue when calling the function set_security_override_from_ctx(),
located in kernel/cred.c, which will be used in eCryptfs to override the set
of initial credentials (i'm about to post the patches).
This function accepts an arbitrary string and uses it as a security label to replace
the one in the credentials provided. If the string passed is not yet imported
to SMACK, the 'smack_known_invalid.smk_known' label is applied without this fact
is notified to the caller.
I tried to solve the problem by importing the string during the execution of the
security_secctx_to_secid() hook, so that set_security_override() will never fail.
So, probably the string must be already been imported if no new memory can be
allocated during smack_secctx_to_secid().


> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> > ---
> >  security/smack/smack_lsm.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index e3c9e54..0e7ed31 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -1415,7 +1415,7 @@ static int smack_kernel_act_as(struct cred *new, u32 secid)
> >  	struct task_smack *new_tsp = new->security;
> >  	char *smack = smack_from_secid(secid);
> >  
> > -	if (smack == NULL)
> > +	if (smack == smack_known_invalid.smk_known)
> >  		return -EINVAL;
> >  
> >  	new_tsp->smk_task = smack;
> 
> 
