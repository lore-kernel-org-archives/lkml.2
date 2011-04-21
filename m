Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1DUCm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:42:57 -0400
Received: from smtp.wow.synacor.com ([64.8.70.55]:56175 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1DUCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:42:56 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Apr 2011 22:42:56 EDT
X-Spam-Rating: None
X_CMAE_Category: 0,0 Undefined,Undefined
X-CNFS-Analysis: v=1.1 cv=eKQ+N4rqOQiji9ijAFGVZbvuh9RsgY7ivWxzmg3MFRI= c=1 sm=0 a=EnAg6b0JcI4A:10 a=FKkrIqjQGGEA:10 a=M1VNycxITrcA:10 a=AhRLOILGsKkA:10 a=IkcTkHD0fZMA:10 a=0xuUpNzuAqVGyKJjr2AA:9 a=QEXdDO2ut3YA:10 a=QLvOlBIuGJjmAZ5IHHaCwQ==:117
X-CM-Score: 0
Date: Wed, 20 Apr 2011 22:34:54 -0400 (EDT)
From: Stephen Powell <zlinuxman@wowway.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, 622570@bugs.debian.org
Message-ID: <248142179.74791.1303353294865.JavaMail.root@md01.wow.synacor.com>
In-Reply-To: <20110418115141.GA3157@osiris.boeblingen.de.ibm.com>
Subject: Re: [OOPS s390] Unable to handle kernel pointer dereference at
 virtual kernel address (null)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [75.118.95.22]
X-Mailer: Zimbra 6.0.5_GA_2328.RHEL5_64 (zclient/6.0.5_GA_2328.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 07:51:41 -0400 (EDT), Heiko Carstens wrote:
> 
> That's a bug in the pfault interrupt code. After a cleanup patch which
> simplified lowcore accesses we are left with a dereference which shouldn't
> be there.  The patch below should fix it.
> The bug was introduced with 2.6.37-rc1.
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 9217e33..4cf85fe 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -558,9 +558,9 @@ static void pfault_interrupt(unsigned int ext_int_code,
>  	 * Get the token (= address of the task structure of the affected task).
>  	 */
>  #ifdef CONFIG_64BIT
> -	tsk = *(struct task_struct **) param64;
> +	tsk = (struct task_struct *) param64;
>  #else
> -	tsk = *(struct task_struct **) param32;
> +	tsk = (struct task_struct *) param32;
>  #endif
>  
>  	if (subcode & 0x0080) {

I applied the above patch and re-built the kernel.  I did not apply
Jan Glauber's suggested patch, since Heiko's suggested patch seemed to be a
"direct hit".  I have had the server up for more than 24 hours now,
which is definitely a good sign.  Without this patch, I've not been able
to keep a 2.6.38 s390x kernel up for more than a few hours.  Unfortunately,
since I can't reproduce the problem on demand, I cannot say with 100%
certainty that the problem is fixed, but it looks good and makes sense.

-- 
  .''`.     Stephen Powell    
 : :'  :
 `. `'`
   `-
