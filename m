Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2HaX7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:59:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35623 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2HaX7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:59:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@parisplace.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
References: <20120831213126.GA19688@www.outflux.net>
	<20120831223908.4aa5574d@pyramind.ukuu.org.uk>
	<CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com>
Date: Fri, 31 Aug 2012 16:59:36 -0700
In-Reply-To: <CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com>
	(Eric Paris's message of "Fri, 31 Aug 2012 15:49:00 -0700")
Message-ID: <87ipbyfw9j.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19G4inQzqqH6L+KPNLlShCWhkpPK+GehIA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Paris <eparis@parisplace.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] security: unconditionally call Yama
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@parisplace.org> writes:

> On Fri, Aug 31, 2012 at 2:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Fri, 31 Aug 2012 14:31:26 -0700
>> Kees Cook <keescook@chromium.org> wrote:
>>
>>> Unconditionally call Yama, no matter what LSM module is selected.
>
>> Not a good plan. What happens when everyone decides to stack every module
>> by ifdeffing in the kernel - mayhem. I'm all for it being possible but
>> done right - espeicall as I believe a proper proposal now for stacking
>> modules, and it should be done as part of that.
>
> I think a lot of us agree it's a 'difficult' plan going forward.  Kees
> wrote this patch after we (James, SELinux, AppArmor people) talked at
> the Security Summit earlier today.  From my PoV we have a couple of
> 'classes' of LSMs.
>
> Big with Labels: SELinux and SMACK
> Big without Labels: AppArmor and TOMOYO
> Small and stateless: Capabilities and Yama (and maybe integrity)
>
> Those small and stateless LSMs can easily stack.  We don't have object
> lifetime issues.  We don't have difficult technical details.  We all
> here seem to want to stack 'small and stateless' with 'big boy'.
> Outside one little capabilities and selinux setxattr issue I can't
> think of anything even quirky.  So the fast path forward, in my mind,
> is to start here with Yama.  Our choice *today* is adding these static
> hooks inside the 'big boy' LSMs (which I think all of us are willing
> to do) vs adding it one time in the LSM and not having to worry about
> it all over the place.  Getting the big guys and the little guys to
> play together is not going to lead to a mess of crazy.
>
> Stacking the big boys is a future goal most of us are happy with
> seeing done, if it turns out to be reasonable.  We know it's close to
> possible.  Dave Howell's gave us an implementation about 2 years ago.
> Casey Schaufler demo'd another stacking interface today.  No code from
> the latter, but the only limitation he really mentioned today was that
> two big guys with labels can't stack together.  I don't know how/if
> Dave's implementation wanted to handle that case.
>
> I really think this patch is good.
>
> Acked-by: Eric Paris <eparis@redhat.com>
>
> I think I even want to do the same thing with capabilities so I don't
> have to make sure I'm getting those right in SELinux.  And everyone
> else probably doesn't want to keep those hooks themselves either.  I
> should send that patch to Linus.  I bet I can give him a large
> negative diff.  He did just say two days ago that he'll take any -1000
> line diff after -rc6   :)
>
> I think Casey and Dave need to both get their larger stacking
> solutions posted and we should go with the best one.  It'll let us
> pull out the static code, but for now, I like the static coding
> between the big boys and the little guys.  Lets fix today what's easy
> and fix tomorrow what we can't fix today.

>From a overal kernel maintenance and use perspective the unconditional
enablement is a pain.

We long ago established the principle that compiling additional code
into the kernel should not change the semenatics of the kernel.

So this code needs to come with a command line or sysctl on/off switch
not an unconditional enable.

Eric
