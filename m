Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2C1CTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:19:17 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:44069 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756788Ab2C1CTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:19:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
References: <20120326150924.GG19395@moon> <20120326164347.GA24394@redhat.com>
	<20120326183330.GM19395@moon> <20120327152534.GA18478@redhat.com>
	<20120327165853.GH11875@moon> <20120327222923.GA31692@mail.hallyn.com>
	<20120327223420.GB9669@moon> <20120327224640.GA5328@mail.hallyn.com>
Date: Tue, 27 Mar 2012 19:22:48 -0700
In-Reply-To: <20120327224640.GA5328@mail.hallyn.com> (Serge E. Hallyn's
	message of "Tue, 27 Mar 2012 22:46:40 +0000")
Message-ID: <m162dpo45j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/dyR62bVkbBCF39WST50bAY6l8RaGNMnE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: openvz.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2968]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Cyrill Gorcunov (gorcunov@openvz.org):
>> On Tue, Mar 27, 2012 at 10:29:23PM +0000, Serge E. Hallyn wrote:
>> > Quoting Cyrill Gorcunov (gorcunov@openvz.org):
>> > > On Tue, Mar 27, 2012 at 05:25:34PM +0200, Oleg Nesterov wrote:
>> > > > user_ns_map_uid() should translate uid_t from one namespace to another,
>> > > > in this case the namespace is the same.
>> > > > 
>> > > > user_ns_map_uid(cred->user_ns, cred) must be the identical mapping,
>> > > > no matter how we change the implementation.
>> > > > 
>> > > > What I think you need is
>> > > > user_ns_map_uid(current_user_ns(), filp->f_owner.cred), the only
>> > > > problem is that f_owner.cred doesn't exist.
>> > > > 
>> > > 
>> > > Hmm, I was confused by likely() in user_ns_map_uid. But indeed, I think
>> > > you're so right. Is there some reason why we can't carry f_owner.cred
>> > > pointer?
>> > 
>> > We would need that for this, yes.  However, Eric is working on a new
>> > patchset which changes the cross-userns uid mappings.  I think it's
>> > worth simply leaving a comment that this will need to be addressed,
>> > and leave in the unconverted uid.
>> 
>> Hi Serge, thanks for info. But if it will be unconverted uid, can't
>> be there some security problem with that which I missed?

I would suggest the easy route and create a KCONFIG dependency
on !CONFIG_USER_NS until the code for that is a little farther along.

Hopefully later this week or begginning of next week I should be posting
my patches and seeing how well the rest of the world takes them.

> Noone is really using the user namespaces right now, but rather than
> adding the cred (and refcounting concerns), my suggestion for now
> would be to hardcode a check in modown() that current_user_ns() ==
> &init_user_ns.
>
> I *did* have a patch in the past which added the cred to fown, but
> no idea where it is right now...

So I guess there are two questions.
- Does it make sense besides translation to add a cred here in general?

- How will it work with the user_namespace?

  I am just about ready to post a patchset that at the edges of
  userspace maps all uid and gids into uid and gids in the initial user
  namespace.

  There is a lot of noise but in net the code is terribly simple, easy
  to maintain and measurably faster (when compiled out) than what we are
  doing now, and most importantly it has a reasonable chance of catching
  all of the permission checks.

  And I have already converted fcntl.  So once my patchset goes in it
  should take all of 5 seconds to get the compile error and fix the code
  to be user_namespace friendly.

Eric

