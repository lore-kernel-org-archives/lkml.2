Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1JSVfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:35:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44087 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1JSVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:35:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>, netdev@vger.kernel.org
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
	<1318974898-21431-10-git-send-email-serge@hallyn.com>
Date: Wed, 19 Oct 2011 06:52:28 -0700
In-Reply-To: <1318974898-21431-10-git-send-email-serge@hallyn.com> (Serge
	Hallyn's message of "Tue, 18 Oct 2011 21:54:58 +0000")
Message-ID: <m1sjmpytpf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19cywq7BW9TEU43yEV0yth1mu207XoRiVk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 DATE_IN_PAST_06_12 Date: is 6 to 12 hours before Received: date
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 9/9] make net/core/scm.c uid comparisons user namespace aware
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge@hallyn.com> writes:

> From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
>
> Currently uids are compared without regard for the user namespace.
> Fix that to prevent tasks in a different user namespace from
> wrongly matching on SCM_CREDENTIALS.
>
> In the past, either your uids had to match, or you had to have
> CAP_SETXID.  In a namespaced world, you must either (both be in the
> same user namespace and have your uids match), or you must have
> CAP_SETXID targeted at the other user namespace.  The latter can
> happen for instance if uid 500 created a new user namespace and
> now interacts with uid 0 in it.

Serge this approach is wrong.

Because we pass the cred and the pid through the socket socket itself
is just a conduit and should be ignored in this context.

The only interesting test should be are you allowed to impersonate other
users in your current userk namespace.

So it should be possible to simplify the entire patch to just:
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
 	const struct cred *cred = current_cred();
+	struct user_namespace *ns = cred->user_ns;

-	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == cred->uid   || creds->uid == cred->euid ||
-	      creds->uid == cred->suid) || capable(CAP_SETUID)) &&
-	    ((creds->gid == cred->gid   || creds->gid == cred->egid ||
-	      creds->gid == cred->sgid) || capable(CAP_SETGID))) {
+	if ((creds->pid == task_tgid_vnr(current) || ns_capable(ns, CAP_SYS_ADMIN)) &&
+	    ((creds->uid == cred->uid   || creds->uid == cred->euid ||
+	      creds->uid == cred->suid) || ns_capable(ns, CAP_SETUID)) &&
+	    ((creds->gid == cred->gid   || creds->gid == cred->egid ||
+	      creds->gid == cred->sgid) || ns_capable(ns, CAP_SETGID))) {
  	       return 0;
  	}
  	return -EPERM;
  }
