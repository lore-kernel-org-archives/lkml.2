Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1BBS7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:59:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57922 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1BBS7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:59:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Marcus Meissner <meissner@suse.de>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org
References: <20110202174015.GB25515@suse.de>
Date: Wed, 02 Feb 2011 10:59:30 -0800
In-Reply-To: <20110202174015.GB25515@suse.de> (Marcus Meissner's message of
	"Wed, 2 Feb 2011 18:40:15 +0100")
Message-ID: <m139o6qn3h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Wm/xZJoINdCStrL4kU1kgTmavzZMJ3jo=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Marcus Meissner <meissner@suse.de>
X-Spam-Relay-Country: 
Subject: Re: af_unix unix_getname: return size for unnamed sockets too small?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Meissner <meissner@suse.de> writes:

> Hi,
>
> In net/unix/af_unix.c::unix_getname() there is a small problem:
>
>         if (!u->addr) {
>                 sunaddr->sun_family = AF_UNIX;
>                 sunaddr->sun_path[0] = 0;		// not copied out
>                 *uaddr_len = sizeof(short);
>         } else {
>                 struct unix_address *addr = u->addr;
>
>                 *uaddr_len = addr->len;
>                 memcpy(sunaddr, addr->name, *uaddr_len);
>         }
>
> The if (!u->addr) case will not copy out the \0 in the sun_path, as
> uaddr_len is just the size of sun_family.
>
> (Shown by socat crashing after decoding gethostname return and expected
> sun_path to be a valid string (and not seeing the \0)).

Perhaps my memory is scrambled but the sun_path has embedded '\0's so I
don't see how a correct application can expect the path to be '\0'
terminated.  An application should be looking at the length we give it.

> Should it perhaps be *uaddr_len = sizeof(short)+sizeof(char)?

I don't think so.

Eric

