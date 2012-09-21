Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2IUFPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:15:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63097 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2IUFPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:15:18 -0400
Date: Thu, 20 Sep 2012 22:12:40 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] charger-manager: Add support sysfs entry for charger
Message-ID: <20120921051239.GA31443@lizard>
References: <1345536409-25880-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345536409-25880-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:06:49PM +0900, Chanwoo Choi wrote:
> This patch add support sysfs entry for each charger(regulator).
> Charger-manager use one or more chargers for charging battery but
> some charger isn't necessary on specific scenario. So, if some charger
> isn't needed, can disable specific charger through 'externally_control'
> entry while system is on state and confirm the information(name, state)
> of charger.
> 
> the list of added sysfs entry
> - /sys/class/power_supply/battery/chargers/charger.[index]/name
> : show name of charger(regulator)
> - /sys/class/power_supply/battery/chargers/charger.[index]/state
> : show either enabled or disabled state of charger
> - /sys/class/power_supply/battery/chargers/charger.[index]/externally_control

The API looks sane.

For the future, you might want to get rid of the 'name', and instead
just point to a regulator device (via a sysfs symlink). I.e.

/sys/class/power_supply/battery/chargers/charger.[index]/device
would be a symlink to the regulator device.

But for the time being, I guess it's OK as is (although I wouldn't
mind if it'll use the symlink from the start. :-)

[...]
>  		for (j = 0 ; j < charger->num_cables ; j++) {
>  			struct charger_cable *cable = &charger->cables[j];
> @@ -1287,6 +1386,71 @@ static int charger_manager_probe(struct platform_device *pdev)
>  			cable->charger = charger;
>  			cable->cm = cm;
>  		}
> +
[...]
> +		charger->attr_g.attrs = charger->attrs;
> +
> +		sysfs_attr_init(&cable->attr_name.attr);

Notice that 'cable' is declared in the 'for' loop above,
so this doesn't compile for me:

  CHECK   drivers/power/charger-manager.c
drivers/power/charger-manager.c:1559:17: error: undefined identifier 'cable'
drivers/power/charger-manager.c:1564:17: error: undefined identifier 'cable'
drivers/power/charger-manager.c:1569:17: error: undefined identifier 'cable'
  CC      drivers/power/charger-manager.o
drivers/power/charger-manager.c: In function ‘charger_manager_probe’:
drivers/power/charger-manager.c:1559:3: error: ‘cable’ undeclared (first use in this function)
drivers/power/charger-manager.c:1559:3: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [drivers/power/charger-manager.o] Error 1

Also:
- Please adhere to the codingstyle, there should be no spaces
  before ';' in the for loop statement.
- If possible, please consider splitting _probe routine, it is more
  than 300 lines long nowadays.

Thanks,
Anton.
