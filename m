Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab2HaH7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:59:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24283 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2HaH7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:59:19 -0400
X-AuditID: cbfee60b-b7f256d000005308-eb-50406ed6c654
Date: Fri, 31 Aug 2012 07:59:18 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] [2/2] extcon: optimising the check_mutually_exclusive
 function
To: anish kumar <anish198519851985@gmail.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120831075900111@myungjoo.ham
Msgkey: 20120831075900111@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120831075900111@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7520099.93351346399957499.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/t6brX8hwCDK4fZLO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZUzt2shW846tYP+kGSwPjDr4uRk4OIQF1iUVLTrKB2BICJhJb
	ds1ngbDFJC7cWw8U5wKqmc8ocXDPVSaQBIuAqsSbj7eYuxg5ONgE9CRmfk4GCQsLhEvM/LsT
	rEREIEdi1spmMJtZwFHi0eU7zBC7lCTW7HsFNp9XQFDi5MwnULtUJZ5e2AU2kldATaL3FhNE
	WEJi1vQLrBA2r8SM9qdQ5XIS076uYYawpSXOz9rACHPy4u+PoeL8Esdu72ACGQnS++R+MMyY
	3Zu/QH0rIDH1zEGoVi2JpXuboGw+iTUL37LAjNl1ajkzTO/9LXOhvlKUmNL9kB3C1pL48mMf
	G7qveAUcJCaemcgygVFuFpLULCTts5C0I6tZwMiyilE0tSC5oDgpPdVQrzgxt7g0L10vOT93
	EyM4xp9x72Cc1WBxiFGAg1GJh7djl32AEGtiWXFl7iFGCQ5mJRFeNiuHACHelMTKqtSi/Pii
	0pzU4kOM0hwsSuK8n72++gsJpCeWpGanphakFsFkmTg4pRoYC7tDsqYUii3l4rzama15dE9M
	XHDsbu/O1bGrHgdPcLzPLjI7S/Q/x4bCpXVZgraHmbbtPRq0bKndrWMCE5fNzdjlcGBf8l+2
	oo/rr2/nms99Y8ffh6p16fKBMuKeUjZzThfwzX+1tIlX98jee8cfWnMaBPOzrFjF8fvLU4fI
	u0FFW44ot6+Yp8RSnJFoqMVcVJwIAJQistDtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7V7xQw8028304

> From: anish kumar <anish198519851985@gmail.com>
> 
> Rather than re-inventing the wheel we can use the hamming function
> to calculate the number of bits set to check for violation of
> exclusivity.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>

Ah.. we've got such a convinient one. Thanks.

Singed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>


> ---
>  drivers/extcon/extcon-class.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index e09a6c3..06df95a 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -89,17 +89,13 @@ static int check_mutually_exclusive(struct extcon_dev *edev, u32 new_state)
>  		return 0;
>  
>  	for (i = 0; edev->mutually_exclusive[i]; i++) {
> -		int count = 0, j;
> +		int weight;
>  		u32 correspondants = new_state & edev->mutually_exclusive[i];
> -		u32 exp = 1;
> -
> -		for (j = 0; j < 32; j++) {
> -			if (exp & correspondants)
> -				count++;
> -			if (count > 1)
> -				return i + 1;
> -			exp <<= 1;
> -		}
> +
> +		/* calculate the total number of bits set */
> +		weight = hweight32(correspondants);
> +		if (weight > 1)
> +			return i + 1;
>  	}
>  
>  	return 0;
> -- 
> 1.7.1
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
