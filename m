Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1GYNx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:53:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1GYNx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:53:56 -0400
Message-ID: <4E2D7571.8030108@suse.cz>
Date: Mon, 25 Jul 2011 15:53:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hiromu Yakura <hiromu1996@gmail.com>
Subject: Re: [PATCH] xconfig: merge code path to conf_write()
References: <1306260978-29437-1-git-send-email-lacombar@gmail.com> <20110525131854.GF2276@sepie.suse.cz>
In-Reply-To: <20110525131854.GF2276@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.5.2011 15:18, Michal Marek wrote:
> The following patch avoids the data loss if the configuration cannot be
> saved.
>
> Michal
>
> Subject: [PATCH] xconfig: Abort close if configuration cannot be saved
>
> Give the user an opportunity to fix the error or save the configuration
> under a different path.
>
> Reported-by: Hiromu Yakura<hiromu1996@gmail.com>
> Signed-off-by: Michal Marek<mmarek@suse.cz>

I completely forgot about this patch. It's applied now and will be in 3.1.

Michal
>
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index c2796b8..92bf576 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -1478,10 +1478,13 @@ void ConfigMainWindow::loadConfig(void)
>   	ConfigView::updateListAll();
>   }
>
> -void ConfigMainWindow::saveConfig(void)
> +bool ConfigMainWindow::saveConfig(void)
>   {
> -	if (conf_write(NULL))
> +	if (conf_write(NULL)) {
>   		QMessageBox::information(this, "qconf", _("Unable to save configuration!"));
> +		return false;
> +	}
> +	return true;
>   }
>
>   void ConfigMainWindow::saveConfigAs(void)
> @@ -1642,7 +1645,11 @@ void ConfigMainWindow::closeEvent(QCloseEvent* e)
>   	mb.setButtonText(QMessageBox::Cancel, _("Cancel Exit"));
>   	switch (mb.exec()) {
>   	case QMessageBox::Yes:
> -		saveConfig();
> +		if (saveConfig())
> +			e->accept();
> +		else
> +			e->ignore();
> +		break;
>   	case QMessageBox::No:
>   		e->accept();
>   		break;
> diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
> index 91677d9..3715b3e 100644
> --- a/scripts/kconfig/qconf.h
> +++ b/scripts/kconfig/qconf.h
> @@ -311,7 +311,7 @@ public slots:
>   	void listFocusChanged(void);
>   	void goBack(void);
>   	void loadConfig(void);
> -	void saveConfig(void);
> +	bool saveConfig(void);
>   	void saveConfigAs(void);
>   	void searchConfig(void);
>   	void showSingleView(void);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

