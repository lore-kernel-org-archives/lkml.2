Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2JSGxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:53:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33092 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2JSGxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121019055943.GA4185@localhost.localdomain>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
	<CAOh2x=mdtkW=a-xv1BeHxoGsgbF5s+4B8QmZBdvqnWHr30Ap2A@mail.gmail.com>
	<20121019055943.GA4185@localhost.localdomain>
Date: Fri, 19 Oct 2012 12:23:08 +0530
X-Google-Sender-Auth: L0HTjR0qbputBtkHP-9b8avNvEo
Message-ID: <CAOh2x=kXu2EG4GFaW8HpSi=VFLvGEMEyeN_3L74wU2sfe1Z=uQ@mail.gmail.com>
Subject: Re: [PATCH] pwm: add spear pwm driver support
From: viresh kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, spear--sw-devel@lists.codex.cro.st.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 11:29 AM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> On Thu, Oct 18, 2012 at 11:11:06PM +0530, viresh kumar wrote:
>> On Thu, Oct 18, 2012 at 4:58 PM, Shiraz Hashim <shiraz.hashim@st.com> wrote:

>> > +static int __devexit spear_pwm_remove(struct platform_device *pdev)
>> > +{
>> > +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
>> > +       int i;
>> > +
>> > +       if (WARN_ON(!pc))
>> > +               return -ENODEV;
>> > +
>> > +       for (i = 0; i < NUM_PWM; i++) {
>> > +               struct pwm_device *pwmd = &pc->chip.pwms[i];
>> > +
>> > +               if (!test_bit(PWMF_ENABLED, &pwmd->flags))

One point here: If i am not wrong you want to disable pwmd if it is enabled.
Shouldn't you check for if (test_bit(PWMF_ENABLED, &pwmd->flags)) instead?

>> > +                       if (clk_prepare_enable(pc->clk) < 0)
>> > +                               continue;
>> > +
>> > +               spear_pwm_writel(pc, i, PWMCR, 0);
>> > +               clk_disable_unprepare(pc->clk);
>> > +       }
>>
>> You are enabling/disabling clock N times here and each of these will
>> write to an register. Do something better.
>>
>
> I need to shut down all active pwms, how else would you suggest that ?

Sorry, i misread the code on the second go :(

I am proposing something like:

static int __devexit spear_pwm_remove(struct platform_device *pdev)
{
       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
       int i, clk_enabled = 0;

       if (WARN_ON(!pc))
               return -ENODEV;

       for (i = 0; i < NUM_PWM; i++) {
               struct pwm_device *pwmd = &pc->chip.pwms[i];

               if (!test_bit(PWMF_ENABLED, &pwmd->flags) && !clk_enabled)
                       if (clk_prepare_enable(pc->clk) < 0)
                               continue;
		       else
			       clk_enabled++;

               spear_pwm_writel(pc, i, PWMCR, 0);
       }

       if (clk_enabled)
	       clk_disable_unprepare(pc->clk);
       ...
}
