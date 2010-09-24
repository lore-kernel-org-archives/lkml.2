Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0IXRHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:07:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58011 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0IXRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:06:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Andrew Lutomirski <luto@mit.edu>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ulrich Drepper <drepper@gmail.com>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Jan Engelhardt <jengelh@medozas.de>, linux-fsdevel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux Containers <containers@lists.osdl.org>,
        Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Al Viro <viro@ZenIV.linux.org.uk>
References: <m1ocborgq7.fsf@fess.ebiederm.org> <4C9CA16F.3000505@mit.edu>
	<4C9CAC7C.2080900@free.fr>
Date: Fri, 24 Sep 2010 10:06:41 -0700
In-Reply-To: <4C9CAC7C.2080900@free.fr> (Daniel Lezcano's message of "Fri, 24
	Sep 2010 15:49:48 +0200")
Message-ID: <m1fwwzdqam.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Lezcano <daniel.lezcano@free.fr>
X-Spam-Relay-Country: 
Subject: Re: [ABI REVIEW][PATCH 0/8] Namespace file descriptors
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <daniel.lezcano@free.fr> writes:

> On 09/24/2010 03:02 PM, Andrew Lutomirski wrote:
>> Eric W. Biederman wrote:
>>> Introduce file for manipulating namespaces and related syscalls.
>>> files:
>>> /proc/self/ns/<nstype>
>>>
>>> syscalls:
>>> int setns(unsigned long nstype, int fd);
>>> socketat(int nsfd, int family, int type, int protocol);
>>>
>>
>> How does security work?  Are there different kinds of fd that give (say) pin-the-namespace permission, socketat permission, and setns permission?
>
> AFAICS, socketat, setns and "set netns by fd" only accept fd from
> /proc/<pid>/ns/<ns>.
>
> setns does :
>
> 	file = proc_ns_fget(fd);
> 	if (IS_ERR(file))
> 		return PTR_ERR(file);
>
> proc_ns_fget checks if (file->f_op != &ns_file_operations)
>
>
> socketat and get_net_ns_by_fd:
>
> 	net = get_net_ns_by_fd(fd);
>
> this one calls proc_ns_fget.
>
> We have the guarantee here, the fd is resulting from an open of the file with
> the right permissions.

In particular the default /proc permissions say you have to be the owner
of the process (or root) to access the file.  If you are the owner of
the process with a namespace (or root) you already have permission to
access and manipulate the namespace.

Additionally setns like unshare requires CAP_SYS_ADMIN (aka root magic).

> Another way to pin the namespace, would be to mount --bind /proc/<pid>/ns/<ns>
> but we have to be root to do that ...

Simply keeping the process running, pins the namespace. That requires no
new permissions.

Similarly socketat.  It is possible to use unix domain sockets to
implement it today without any kernel changes.  It is just an
unnecessary pain to run a server process to pin a namespace or to serve
up file descriptors in other network namespaces.

The primary change of this patchset is the ability to do everything
with file descriptors, and with the mount namespace.  That moves
everything from a bizarre hard to understand and manipulate interface
to one where things can be done much more easily, and cheaply.
Resulting in a much more powerful and usable interface.

Eric

