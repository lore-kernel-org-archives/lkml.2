Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1HSSjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:39:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38727 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1HSSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:39:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>, containers@lists.osdl.org
References: <4E4CDF44.5080109@redhat.com> <m17h69sr03.fsf@fess.ebiederm.org>
	<4E4E395B.7070106@redhat.com> <m1liup4oes.fsf@fess.ebiederm.org>
	<4E4E503B.3050406@redhat.com>
Date: Fri, 19 Aug 2011 11:39:20 -0700
In-Reply-To: <4E4E503B.3050406@redhat.com> (Milan Broz's message of "Fri, 19
	Aug 2011 13:59:55 +0200")
Message-ID: <m1vctt2qlj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+gWA/fvqCLqo8Oyvu8BsNB9noeAydOD18=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Milan Broz <mbroz@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz <mbroz@redhat.com> writes:

> On 08/19/2011 01:43 PM, Eric W. Biederman wrote:
>> Milan Broz <mbroz@redhat.com> writes:
>> 
>>> On 08/19/2011 11:13 AM, Eric W. Biederman wrote:
>>>> Milan Broz <mbroz@redhat.com> writes:
>>>>
>>>> I think the proper fix is to remove the error return from
>>>> kobject_uevent_env and kobject_uevent, and make it harder to get calling
>>>> of this function wrong.  Possibly in conjunction with that tag all of
>>>> the memory allocations of kobject_uevent_env with GFP_NOFAIL or
>>>> something so the memory allocator knows that this path is totally
>>>> not able to deal with failure.
>>>>
>>>> Is kobject_uevent_env anything except an asynchronous best effort
>>>> notification to user-space that a device has come or gone?
>>>
>>> Unfortunately it is for device-mapper. libdevmapper
>>> depends on information that uevent was sent because udev rules uses
>>> semaphore to inform that some action was taken.
>>> So if dm-ioctl returns flag that uevent was not sent, it fallback
>>> to different error path (otherwise it waits for completion forever).
>>> (TBH I am more and more convinced this was not quite clever concept.)
>> 
>> If I understand your description and the code right the guarantee that
>> you need is that kobject_uevent will return success only if it has
>> queued a packet in every listening netlink socket.
>
> I think so. IOW success == event was sent to all active listeners.
>
>> We already ignore ENOBUFS so the guarantee you appear to need in
>> libdevmapper does not appear to be present in kobject_uevent.
>> 
>> Does the libdevmapper code work despite getting a spurious failure?
>
> BTW I do not see ENOBUFS but ESRCH (from netlink_broadcast_filtered).
>
> If spurious failure is that event is sent (even partially) but it reports
> failure, it is the exact situation I see now - libdevmapper will try
> to decrement system semaphore which is already removed from udev rules.
>
> Final state is correct, just it prints ugly warnings. IOW it recovers
> from this situation correctly.

Then I guess this is fixable in kobject_uevent_env.  I'm not certain
it is smart to support this case but it appears supportable.

> But Kay's suggestion to use netlink_has_listeners() seems like good
> idea. IOW if there is no listener, it should skip quietly and not
> fail the whole call...

In the case of ESRCH I completely agree.

We are currently ignoring errors in the semantically more interesting
case when netlink_broadcast does not deliver the packet to one of the
listening netlink sockets.

How does this patch look?
---

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 70af0a7..7da5ef3 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -139,6 +139,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	u64 seq;
 	int i = 0;
 	int retval = 0;
+	bool delivery_failed;
 #ifdef CONFIG_NET
 	struct uevent_sock *ue_sk;
 #endif
@@ -251,6 +252,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	if (retval)
 		goto exit;
 
+	delivery_failure = false;
 #if defined(CONFIG_NET)
 	/* send netlink message */
 	mutex_lock(&uevent_sock_mutex);
@@ -281,14 +283,15 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 							    0, 1, GFP_KERNEL,
 							    kobj_bcast_filter,
 							    kobj);
-			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
-				retval = 0;
+			if (retval && (retval != -ESRCH))
+				delivery_failure = true;
 		} else
-			retval = -ENOMEM;
+			delivery_failure = true;
 	}
 	mutex_unlock(&uevent_sock_mutex);
 #endif
+	if (delivery_failure)
+		retval = -ENOBUFS;
 
 	/* call uevent_helper, usually only enabled during early boot */
 	if (uevent_helper[0] && !kobj_usermode_filter(kobj)) {

