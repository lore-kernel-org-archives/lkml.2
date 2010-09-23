Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0IWQQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:16:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49350 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab0IWQQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:16:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Brian Haley <brian.haley@hp.com>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	<m1hbhgq1v1.fsf@fess.ebiederm.org> <4C9B62A1.7020606@hp.com>
Date: Thu, 23 Sep 2010 09:16:04 -0700
In-Reply-To: <4C9B62A1.7020606@hp.com> (Brian Haley's message of "Thu, 23 Sep
	2010 10:22:25 -0400")
Message-ID: <m18w2sh1vf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Brian Haley <brian.haley@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Haley <brian.haley@hp.com> writes:

> On 09/23/2010 04:51 AM, Eric W. Biederman wrote:
>> 
>> Take advantage of the new abstraction and allow network devices
>> to be placed in any network namespace that we have a fd to talk
>> about.
>> 
> ...
>> +struct net *get_net_ns_by_fd(int fd)
>> +{
>> +	struct proc_inode *ei;
>> +	struct file *file;
>> +	struct net *net;
>> +
>> +	file = NULL;
>
> No need to initialize this.
>
>> +	net = ERR_PTR(-EINVAL);
>
> or this?
>
>> +	file = proc_ns_fget(fd);
>> +	if (!fd)
>> +		goto out;
>> +		return ERR_PTR(-EINVAL);
>
> Shouldn't this be:
>
> 	if (!file)
>
> And the "goto" seems wrong, especially without a {} here.  Unless you
> meant to keep the "goto" and branch below?

I think I changed my mind half way through writing the code and never
did anything about it.  Oops.

Thanks fixed.  It is now:

struct net *get_net_ns_by_fd(int fd)
{
	struct proc_inode *ei;
	struct file *file;
	struct net *net;

	net = ERR_PTR(-EINVAL);
	file = proc_ns_fget(fd);
	if (!file)
		goto out;

	ei = PROC_I(file->f_dentry->d_inode);
	if (ei->ns_ops != &netns_operations)
		goto out;

	net = get_net(ei->ns);
out:
	if (file)
		fput(file);
	return net;
}

Which at least makes sense.  Now to test it to double check it does what
it should do.

Eric
