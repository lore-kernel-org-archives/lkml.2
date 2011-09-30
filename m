Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab1I3Hpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:45:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38523 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab1I3Hp3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Fri, 30 Sep 2011 03:45:29 -0400
Message-Id: <4E858FB60200007800058A99@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 30 Sep 2011 08:45:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Dan Carpenter" <error27@gmail.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/9] xen/pciback: Return proper error
	 code from sscanf.
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1317325971-21603-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.09.11 at 21:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> . instead of just hardcoding it to be -EINVAL.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xen-pciback/pci_stub.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> b/drivers/xen/xen-pciback/pci_stub.c
> index 32d6891..d985b65 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -868,7 +868,7 @@ static inline int str_to_slot(const char *buf, int 
> *domain, int *bus,
>  	if (err == 4)
>  		return 0;
>  	else if (err < 0)
> -		return -EINVAL;
> +		return err;
>  
>  	/* try again without domain */
>  	*domain = 0;

This should then also be done for the final return from the function:

	return err < 0 ? err : -EINVAL;

But: Where did you read that {v,}sscanf() would return -E... values in
hypothetical error cases? The C standard says it would return EOF
when reaching the end of the input string before doing the first
conversion; lib/vsprintf.c doesn't do so, and also doesn't say it might
return -E... codes. Bottom line is that I think the code is more correct
the way it is without this change.

Jan

