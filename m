Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0LMVfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:35:36 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55503 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab0LMVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:35:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>, linux-kernel@vger.kernel.org
References: <1292259913-9911-1-git-send-email-kirill@shutemov.name>
Date: Mon, 13 Dec 2010 13:35:25 -0800
In-Reply-To: <1292259913-9911-1-git-send-email-kirill@shutemov.name> (Kirill
	A. Shutsemov's message of "Mon, 13 Dec 2010 19:05:13 +0200")
Message-ID: <m1sjy1uzj6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/pKOwkHWl4XacamntfIuJZyVY5q+IiCqA=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Kirill A. Shutsemov" <kirill@shutemov.name>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] netlink: fix gcc -Wconversion compilation warning
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutsemov" <kirill@shutemov.name> writes:

> From: Dmitry V. Levin <ldv@altlinux.org>
>
> $ cat << EOF | gcc -Wconversion -xc -S -o/dev/null -
> unsigned f(void) {return NLMSG_HDRLEN;}
> EOF
> <stdin>: In function 'f':
> <stdin>:3:26: warning: negative integer implicitly converted to unsigned type
>
This doesn't look like a bad fix, but I believe things will fail if
we give NLMSG_ALIGN an unsigned long like size_t.  Say like sizeof.

Admittedly it has to be a huge size but still if we are going
to go fixing things...

And then there is the silliness that NLMSG_HDRLEN forces itself
to be an int, when it start out as a size_t.

So I think NLMSG_ALIGN either needs to operation exclusively
on unsigned longs aka size_t, or it needs to be type preserving.

Do you have time to look at this a bit more?


> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  include/linux/netlink.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 1235669..e2b9e63 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -70,7 +70,7 @@ struct nlmsghdr {
>     Check		NLM_F_EXCL
>   */
>  
> -#define NLMSG_ALIGNTO	4
> +#define NLMSG_ALIGNTO	4U
>  #define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
>  #define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
>  #define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(NLMSG_HDRLEN))
