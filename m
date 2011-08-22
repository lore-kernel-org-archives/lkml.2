Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1HVTtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:49:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55722 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1HVTt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:49:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, kay.sievers@vrfy.org,
        greg@kroah.com
References: <4E4ECA5D.1020907@redhat.com>
	<1314021094-15453-1-git-send-email-mbroz@redhat.com>
Date: Mon, 22 Aug 2011 12:49:19 -0700
In-Reply-To: <1314021094-15453-1-git-send-email-mbroz@redhat.com> (Milan
	Broz's message of "Mon, 22 Aug 2011 15:51:34 +0200")
Message-ID: <m1hb59w7k0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+bkiJRST0TEjTp0A5suGuGT4c0fQ1KAec=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 XM_URI_RBL_RM URI removed in uri.bl.xmission.com
	*      [URIs: gmane.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Milan Broz <mbroz@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kobj_uevent: Ignore if some listeners cannot handle message
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz <mbroz@redhat.com> writes:

> kobject_uevent() uses a multicast socket and should ignore
> if one of listeners cannot handle messages or nobody is
> listening at all.
>
> Easily reproducible when a process in system is cloned
> with CLONE_NEWNET flag.
>
> (See also
> http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5256)

I am fine with the patch below.

However if you are fine with the patch below let's just remove the
return code from code from kobject_uevent_env.  We are now explicitly
ignoring all of the possible return codes from
netlink_broadcast_filtered.  

Ignoring all of the return codes from netlink_broadcast_filtered ignores
all of the expected errors from kobject_uevent_env, short of programmer
error.

So why have an error code on kobject_uevent_env?

> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  lib/kobject_uevent.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
> index 70af0a7..ad72a03 100644
> --- a/lib/kobject_uevent.c
> +++ b/lib/kobject_uevent.c
> @@ -282,7 +282,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  							    kobj_bcast_filter,
>  							    kobj);
>  			/* ENOBUFS should be handled in userspace */
> -			if (retval == -ENOBUFS)
> +			if (retval == -ENOBUFS || retval == -ESRCH)
>  				retval = 0;
>  		} else
>  			retval = -ENOMEM;
