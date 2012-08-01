Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2HAPgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:36:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58423 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab2HAPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:36:52 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        serge@hallyn.com
Subject: Re: ***SPAM*** Re: [PATCH] userns: Convert quota to user kuid/kgid where appropriate
In-Reply-To: <87d33abw7u.fsf@xmission.com>
References: <1343817532-12021-1-git-send-email-dmonakhov@openvz.org> <87d33abw7u.fsf@xmission.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 01 Aug 2012 19:36:46 +0400
Message-ID: <87d33azks1.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2012 06:03:33 -0700, ebiederm@xmission.com (Eric W. Biederman) wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > Map uid/gid to global kuid/kgid before pass it down to quota
> > infrastructure.
> 
> Have you looked at my development branch of my userns tree?
> 
> I already have a patch queued to do something like this. 
Oh. Yes you right. I've missed it.
BTW when do you plan to submit new set?

> 
> Eric
> 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/quota/quota.c |   45 ++++++++++++++++++++++++++++++++++++---------
> >  1 files changed, 36 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > index 6f15578..a59efd4 100644
> > --- a/fs/quota/quota.c
> > +++ b/fs/quota/quota.c
> > @@ -19,8 +19,13 @@
> >  #include <linux/writeback.h>
> >  
> >  static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
> > -				     qid_t id)
> > +				     qid_t id, qid_t* global_id)
> >  {
> > +	kuid_t kuid;
> > +	kgid_t kgid;
> > +	struct user_namespace *ns = current_user_ns();
> > +	int is_get_query = 0;
> > +
> >  	switch (cmd) {
> >  	/* these commands do not require any special privilegues */
> >  	case Q_GETFMT:
> > @@ -29,11 +34,32 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
> >  	case Q_XGETQSTAT:
> >  	case Q_XQUOTASYNC:
> >  		break;
> > -	/* allow to query information for dquots we "own" */
> >  	case Q_GETQUOTA:
> >  	case Q_XGETQUOTA:
> > -		if ((type == USRQUOTA && current_euid() == id) ||
> > -		    (type == GRPQUOTA && in_egroup_p(id)))
> > +		is_get_query = 1;
> > +	case Q_SETQUOTA:
> > +	case Q_XSETQLIM:
> > +		/* Map to global user namespace */
> > +		switch (type) {
> > +		case USRQUOTA:
> > +			kuid = make_kuid(ns, id);
> > +			if (!uid_valid(kuid))
> > +				return -EINVAL;
> > +			*global_id = from_kuid_munged(&init_user_ns, kuid);
> > +			break;
> > +		case GRPQUOTA:
> > +			kgid = make_kgid(ns, id);
> > +			if (!gid_valid(kgid))
> > +				return -EINVAL;
> > +			*global_id = from_kgid_munged(&init_user_ns, kgid);
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +		/* allow to query information for dquots we "own" */
> > +		if (is_get_query &&
> > +		    ((type == USRQUOTA && uid_eq(current_euid(), kuid)) ||
> > +		     (type == GRPQUOTA && in_egroup_p(kgid))))
> >  			break;
> >  		/*FALLTHROUGH*/
> >  	default:
> > @@ -240,13 +266,14 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
> >  		       void __user *addr, struct path *path)
> >  {
> >  	int ret;
> > +	qid_t qid = -1;
> >  
> >  	if (type >= (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))
> >  		return -EINVAL;
> >  	if (!sb->s_qcop)
> >  		return -ENOSYS;
> >  
> > -	ret = check_quotactl_permission(sb, type, cmd, id);
> > +	ret = check_quotactl_permission(sb, type, cmd, id, &qid);
> >  	if (ret < 0)
> >  		return ret;
> >  
> > @@ -264,9 +291,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
> >  	case Q_SETINFO:
> >  		return quota_setinfo(sb, type, addr);
> >  	case Q_GETQUOTA:
> > -		return quota_getquota(sb, type, id, addr);
> > +		return quota_getquota(sb, type, qid, addr);
> >  	case Q_SETQUOTA:
> > -		return quota_setquota(sb, type, id, addr);
> > +		return quota_setquota(sb, type, qid, addr);
> >  	case Q_SYNC:
> >  		if (!sb->s_qcop->quota_sync)
> >  			return -ENOSYS;
> > @@ -278,9 +305,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
> >  	case Q_XGETQSTAT:
> >  		return quota_getxstate(sb, addr);
> >  	case Q_XSETQLIM:
> > -		return quota_setxquota(sb, type, id, addr);
> > +		return quota_setxquota(sb, type, qid, addr);
> >  	case Q_XGETQUOTA:
> > -		return quota_getxquota(sb, type, id, addr);
> > +		return quota_getxquota(sb, type, qid, addr);
> >  	case Q_XQUOTASYNC:
> >  		if (sb->s_flags & MS_RDONLY)
> >  			return -EROFS;
