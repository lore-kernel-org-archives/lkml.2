Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab0FOSx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:53:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56178 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab0FOSxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Rzxc6qa3uxmb7XxoCIgmCNX+NnZ+vMo/DAXPswSfD9rKJHTa8D9Zcff9f6VjQ1YJ32
         7CqUCQ4NnvL4taVW59LtOiIr+qygW2WiiUqqmyV9zUKP7YP+hJnLA8ohp0kfDnP1MgIh
         Hicky/EZlAqEwU924nTMI/L4pVL6Ku4TuUMw0=
From: "Sergey V." <sftp.mtuci@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but not used
Date: Tue, 15 Jun 2010 22:53:43 +0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.4; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-5-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006152253.44326.sftp.mtuci@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 of June 2010 00:26:44 Justin P. Mattock wrote:
> Im getting this warning when compiling:
>  CC      drivers/char/tpm/tpm.o
> drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
> drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
> 
> The below patch gets rid of the warning,
> but I'm not sure if it's the best solution.
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/char/tpm/tpm.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 05ad4a1..3d685dc 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -514,6 +514,8 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
>  
>  	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the timeouts");
> +	if (!rc)
> +		rc = 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
>  
> -- 
> 1.7.1.rc1.21.gf3bd6
> 

Hi Justin

IMHO
See code of functions tpm_transmit(), transmit_cmd and tpm_gen_interrupt(). 
In tpm_gen_interrupt() not need check rc for wrong value bacause if in function 
transmit_cmd() len == TPM_ERROR_SIZE then put a debug message (dev_dbg()).
Again, if something wrong in tpm_transmit() then runs dev_err() and rc in 
tpm_gen_interrupt() get -E* value.
So, we can remove unused rc variable in tpm_gen_interrupt(). 

See patch below. Note: I not tested it.


Subject: [PATCH] drivers: tpm.c: Remove unused variable 'rc'

---
 drivers/char/tpm/tpm.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 05ad4a1..f9f5b47 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -505,15 +505,14 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, 
cap_t *cap,
 void tpm_gen_interrupt(struct tpm_chip *chip)
 {
 	struct	tpm_cmd_t tpm_cmd;
-	ssize_t rc;
 
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the timeouts");
+	transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+		     "attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
-- 
1.7.1
