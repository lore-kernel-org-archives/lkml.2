Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1G0GCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:02:10 -0400
Received: from nm5.bullet.mail.ac4.yahoo.com ([98.139.52.202]:21569 "HELO
	nm5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752746Ab1G0GCJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:02:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 493996.95733.bm@omp1039.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ExSbjasiDsXgoxmFqUV7FpJyfSuaZbKkxAUTI7Sy5UG525KC4GWhO/npdIyVwpR87eVPf6A5AdLSqVi37ygkEE1TPsmwvR3+DiXOKOqLNhJaC/dYYpitLDDi9RWlLsrt3Tn4DZFCM77tH15uuvAicSNEdiPaqJNz/67jpUEriUU=;
X-YMail-OSG: Ee6JZZoVM1nq7bQ6FVMszziQVN0zF85d0ro1HW5CA4FP4pF
 A40wHVSl0dWqq_QCWDqwoJp0ejEX6NM0.1TDz7.TvFB40_OWSDKfWixgsd.A
 JoGM60pTS2yePMg2_GQ5s69ZsZO54FE5wJWPr8bh.klwJFpMfVpB2SeShSV7
 7qg0P.vsGgxec79e2myn.fdNdhDqulEnCEXynIMSDCNR3j0PswYIkJaZSSCE
 VUaUrDtTYLx.T1_f8yjfVXB6fYblQ6ESmR3KHllGzROSHSmaeGvPdYdX40Jo
 A8Ju0Kz4wZguhA0dPuL9nhjNOUkd8neT4Phngik7hwZ2xtRYzz.yim9QkvQj
 MZMIDyofi7l_rtgE7.HbGW.zDIirAYr1RJnZ2WcPua9_7mkSJSD6z3lL0X61
 zsrnoGYY_zFcl
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com> <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
Message-ID: <1311746527.11636.YahooMailNeo@web31811.mail.mud.yahoo.com>
Date: Tue, 26 Jul 2011 23:02:07 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
To: Jack Wang <jack_wang@usish.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>
In-Reply-To: <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

> From: Jack Wang <jack_wang@usish.com>
> To: 'Luben Tuikov' <ltuikov@yahoo.com>; 'James Bottomley' <James.Bottomley@suse.de>; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Cc: 
> Sent: Tuesday, July 26, 2011 8:26 PM
> Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
> 
> [PATCH] [SCSI] libsas: remove expander from dev list on error
>> 
>>  If expander discovery fails (sas_discover_expander()),
>>  remove the expander from the port device list
>>  (sas_ex_discover_expander()), before freeing it. Else
>>  the list is corrupted and, e.g., when we attempt to send
>>  SMP commands to other devices, the kernel oopses.
>> 
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  ---
>>   drivers/scsi/libsas/sas_expander.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>> 
>>  diff --git a/drivers/scsi/libsas/sas_expander.c
>>  b/drivers/scsi/libsas/sas_expander.c
>>  index 874e29d..f84084b 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
>> 
>>       res = sas_discover_expander(child);
>>       if (res) {
>>  +        spin_lock_irq(&parent->port->dev_list_lock);
>>  +        list_del(&child->dev_list_node);
>>  +        spin_unlock_irq(&parent->port->dev_list_lock);
>>           kfree(child);
>>           return NULL;
>>       }
>>  --
> [Jack Wang] Looks reasonable, thanks for fix this.
> You can add my Reviewed-by: Jack Wang <jack_wang@usish.com> if needed.

Thanks.

Out of curiosity I took a look at my original code from 2005, before Bottomley changed it off git. This bug doesn't happen as the device is added to the port device list only when it is also registered with kobj. I guess that's a moot point now.

    Luben
