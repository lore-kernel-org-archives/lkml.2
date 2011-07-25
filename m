Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1GYPZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:25:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54633 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1GYPZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <4E2D7571.8030108@suse.cz>
References: <1306260978-29437-1-git-send-email-lacombar@gmail.com>
	<20110525131854.GF2276@sepie.suse.cz>
	<4E2D7571.8030108@suse.cz>
Date: Mon, 25 Jul 2011 11:25:15 -0400
Message-ID: <CACqU3MXmMejkTuUPqWQZH6BSXp6q_B5QuVNZbNjU=3s4sukagg@mail.gmail.com>
Subject: Re: [PATCH] xconfig: merge code path to conf_write()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hiromu Yakura <hiromu1996@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, Jul 25, 2011 at 9:53 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 25.5.2011 15:18, Michal Marek wrote:
>>
>> The following patch avoids the data loss if the configuration cannot be
>> saved.
>>
>> Michal
>>
>> Subject: [PATCH] xconfig: Abort close if configuration cannot be saved
>>
>> Give the user an opportunity to fix the error or save the configuration
>> under a different path.
>>
>> Reported-by: Hiromu Yakura<hiromu1996@gmail.com>
>> Signed-off-by: Michal Marek<mmarek@suse.cz>
>
> I completely forgot about this patch. It's applied now and will be in 3.1.
>
gni ? isn't this issue already fixed by
https://patchwork.kernel.org/patch/812862/ which went in v3.0 ??

 - Arnaud

> Michal
>>
>> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
>> index c2796b8..92bf576 100644
>> --- a/scripts/kconfig/qconf.cc
>> +++ b/scripts/kconfig/qconf.cc
>> @@ -1478,10 +1478,13 @@ void ConfigMainWindow::loadConfig(void)
>>        ConfigView::updateListAll();
>>  }
>>
>> -void ConfigMainWindow::saveConfig(void)
>> +bool ConfigMainWindow::saveConfig(void)
>>  {
>> -       if (conf_write(NULL))
>> +       if (conf_write(NULL)) {
>>                QMessageBox::information(this, "qconf", _("Unable to save
>> configuration!"));
>> +               return false;
>> +       }
>> +       return true;
>>  }
>>
>>  void ConfigMainWindow::saveConfigAs(void)
>> @@ -1642,7 +1645,11 @@ void ConfigMainWindow::closeEvent(QCloseEvent* e)
>>        mb.setButtonText(QMessageBox::Cancel, _("Cancel Exit"));
>>        switch (mb.exec()) {
>>        case QMessageBox::Yes:
>> -               saveConfig();
>> +               if (saveConfig())
>> +                       e->accept();
>> +               else
>> +                       e->ignore();
>> +               break;
>>        case QMessageBox::No:
>>                e->accept();
>>                break;
>> diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
>> index 91677d9..3715b3e 100644
>> --- a/scripts/kconfig/qconf.h
>> +++ b/scripts/kconfig/qconf.h
>> @@ -311,7 +311,7 @@ public slots:
>>        void listFocusChanged(void);
>>        void goBack(void);
>>        void loadConfig(void);
>> -       void saveConfig(void);
>> +       bool saveConfig(void);
>>        void saveConfigAs(void);
>>        void searchConfig(void);
>>        void showSingleView(void);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
