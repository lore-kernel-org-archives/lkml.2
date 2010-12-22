Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0LVPK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:10:26 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:41270 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0LVPKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:10:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r6GL9o13gzo8gRC+FUcF9MD6Ml2QhSmX7AEMRYevxAJCCaRNRrsFtT8Xxps/Bv3d6D
         By1u2l3vHBSI0dbsh9ppPc6pTgNQejnYcpArhJdbXCh8LlncR3/kZ/aDi9YTcL2oFMAY
         SGSvnprgE80s/1Z576jWp92siA4Y7j3cq7cwU=
MIME-Version: 1.0
In-Reply-To: <1292855593-30608-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1292855593-30608-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 22 Dec 2010 20:40:23 +0530
X-Google-Sender-Auth: fg7xuLBoc6snjhjUpejrTSrD0-I
Message-ID: <AANLkTi=KOq65TS299rB=K961=mVXnriyqNxdHzJey5rD@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/2] i2c: Factor out runtime suspend checks
 from PM operations
From: Rabin Vincent <rabin@rab.in>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org,
        patches@opensource.wolfsonmicro.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 8:03 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>  static int i2c_device_pm_restore(struct device *dev)
> @@ -267,7 +248,7 @@ static int i2c_device_pm_restore(struct device *dev)
>        int ret;
>
>        if (pm)
> -               ret = pm->restore ? pm->restore(dev) : 0;
> +               ret = pm_generic_restore(dev);
>        else
>                ret = i2c_legacy_resume(dev);

The full function is:

static int i2c_device_pm_restore(struct device *dev)
{
	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
	int ret;

	if (pm)
		ret = pm->restore ? pm->restore(dev) : 0;
	else
		ret = i2c_legacy_resume(dev);

	if (!ret) {
		pm_runtime_disable(dev);
		pm_runtime_set_active(dev);
		pm_runtime_enable(dev);
	}

	return ret;
}

Shouldn't you be deleting the pm_runtime_* stuff from here?  There is
already done in pm_generic_restore() iff the callback exists and returns
zero.
