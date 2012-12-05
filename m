Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2LEWmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:42:11 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50561 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab2LEWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:42:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
To: Viresh Kumar <viresh.kumar@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, rabin.vincent@stericsson.com,
        shiraz.hashim@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linus.walleij@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
In-Reply-To: <CAKohpokLVEH+4F_VXh5auUm48cWWe0mumZME8yOCcAezcwJbCQ@mail.gmail.com>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org> <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org> <20121130105731.GN3176@sortiz-mobl> <20121130154542.GG23648@gmail.com> <CAKohpokLVEH+4F_VXh5auUm48cWWe0mumZME8yOCcAezcwJbCQ@mail.gmail.com>
Date: Wed, 05 Dec 2012 22:42:03 +0000
Message-Id: <20121205224203.691153E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2012 00:33:46 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 30 November 2012 21:15, Lee Jones <lee.jones@linaro.org> wrote:
> > But ... I don't see how the changes in the -i2c and -spi files
> > are of benefit either. When I boot without the ID table I still
> > get "stmpe-i2c 0-0040: stmpe1601 detected, chip id: 0x212".
> >
> > What is it that actually uses the IDs?
> >
> > Perhaps Viresh can shine some light on the matter?
> 
> As you can see, i wasn't the author of this patch and when you asked
> this question, i didn't had an answer to it. I went through code and
> formed some theory/story :) .
> 
> @Grant: i need your help to check if my theory is correct or not. Question
> is about adding below code in any i2c client driver:
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id stmpe_dt_ids[] = {
> +       { .compatible = "st,stmpe610", .data = &stmpe_i2c_id[0], },
> +       { .compatible = "st,stmpe801", .data = &stmpe_i2c_id[1], },
> +       { .compatible = "st,stmpe811", .data = &stmpe_i2c_id[2], },
> +       { .compatible = "st,stmpe1601", .data = &stmpe_i2c_id[3], },
> +       { .compatible = "st,stmpe2401", .data = &stmpe_i2c_id[4], },
> +       { .compatible = "st,stmpe2403", .data = &stmpe_i2c_id[5], },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
> +#endif
> +
>  static struct i2c_driver stmpe_i2c_driver = {
>         .driver = {
>                 .name = "stmpe-i2c",
> @@ -88,6 +102,7 @@ static struct i2c_driver stmpe_i2c_driver = {
>  #ifdef CONFIG_PM
>                 .pm = &stmpe_dev_pm_ops,
>  #endif
> +               .of_match_table = of_match_ptr(stmpe_dt_ids),
> 
> So, what is the use of this table when we already have i2c_driver.id_table
> populated.
> 
> This is my theory:
> ---------------------
> Adapter drivers supporting DT will call:
> of_i2c_register_devices()
> {
> 	for_each_child_of_node(adap->dev.of_node, node) {
> 		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0)
>                      error condition
> 
>                 ...
> 		result = i2c_new_device(adap, &info);
> 
>           ...
> }
> 
> of_modalias_node(): expects compatible in child node, i.e. stmpe node in our
> case. If it is not there, then that node is skipped. then it copies
> string after ','
> to info.type. So, for us only "stmpe810" out of "st,stmpe810" is copied.
> 
> Now this name, i.e. "stmpe810" is copied as client.name in i2c_new_device()
> and device_register() is called, which will eventually call:
> 
> i2c_device_match()
> {
> 	/* Attempt an OF style match */
> 	if (of_driver_match_device(dev, drv))
> 		return 1;
> 
> 	driver = to_i2c_driver(drv);
> 	/* match on an id table if there is one */
> 	if (driver->id_table)
> 		return i2c_match_id(driver->id_table, client) != NULL;
> }
> 
> This first tries to match the table my patch added, _BUT_ the string will
> never match as we had "st,stmpe810" in table and "stmpe810" in dev.

of_driver_match_device() matches against the compatible list in
dev->of_node, not against the device name. So, if the compatible
property has a string that is in the table, then it really should match
against it.

> 
> So, we fall back to i2c_match_id(), which will match it against
> i2c_driver.id_table present in driver, which has entry for "stmpe810" and
> so strings matched.
> 
> @Lee: This is what happened in your case. :)
> 
> So, whether its DT or non DT, true is returned from here if something
> matched.
> 
> Later on, this will be called:
> 
> static int i2c_device_probe(struct device *dev)
> {
>         .....
> 	status = driver->probe(client, i2c_match_id(driver->id_table, client));

Here things are a bit wonky. Even if matched against the table, it is
possible that it also matches against i2c_match_id() and that data is
passed to the driver.

But regardless, it is the responsiblity of the probe function to go and
look if of_driver_match_device() matches against anything if it cares
about the of_match_table entries (for instance, if there is extra data
attached).

>         ....
> }
> 
> Which will again match the legacy table to find correct struct i2c_device_id *id
> to pass to probe().
> 
> So, the final question: WTF is of_match_table for?

A bit of history is valuable here. The whole of_modalias_node() thing is
really just a best-effort heuristic for figuring out which driver
*might* work against a device described in the device tree. It won't
work in all circumstances (and it was created at a time when there was
resistance to adding DT knowledge to drivers). An of_match_table is the
robust way of identifying specific devices and allows for matching
against any entry in the compatible list.

g.
