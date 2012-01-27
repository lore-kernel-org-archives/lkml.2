Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2A0QZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:25:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55978 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2A0QY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:24:59 -0500
Date: Fri, 27 Jan 2012 16:24:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali Roh?r <pali.rohar@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>,
        Sebastian Reichel <sre@debian.org>,
        ???????????? ???????????????? <freemangordon@abv.bg>
Subject: Re: RFC 2: bq2415x_charger driver
Message-ID: <20120127162455.GA18353@sirena.org.uk>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
 <1677656.4d3iQHNZjX@pali-elitebook>
 <3531484.T8K8kTguQQ@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3531484.T8K8kTguQQ@pali>
X-Cookie: When in doubt, lead trump.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:40:43AM +0100, Pali Roh?r wrote:

> +static char *bq2415x_rev_name[] = {
> +	"1.0",
> +	"1.1",
> +	"1.2",
> +	"1.3",
> +	"1.4",
> +	"1.5",
> +	"1.6",
> +	"1.7",

Looks like you can just store this as a number?

> +struct bq2415x_device {
> +	struct device *dev;
> +	struct bq2415x_platform_data *platform_data;

You should take a copy of the platform data so it can be marked
initdata.

> +static DEFINE_MUTEX(bq2415x_id_mutex);
> +static DEFINE_MUTEX(bq2415x_timer_mutex);
> +static DEFINE_MUTEX(bq2415x_type_mutex);
> +static DEFINE_MUTEX(bq2415x_i2c_mutex);

Why are these global?

> +/* i2c read functions */
> +
> +static int bq2415x_i2c_read(struct bq2415x_device *bq, u8 reg)
> +{
> +	struct i2c_client *client = to_i2c_client(bq->dev);

You could save a bunch of code by moving all this I2C register I/O over
to regmap.

> +		case BQ2415X_BOOST_MODE_ENABLE:
> +			return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ2415X_BIT_OPA_MODE);

Keep things under 80 columns - see CodingStyle.

> +	if (client->addr == 0x6b) {

> +	} else if (client->addr == 0x6a) {

This looks like a switch statement.

> +	switch (chip) {
> +		case BQUNKNOWN:
> +			return bq2415x_rev_name[8];

Magic numbers ahoy...

> +static int bq2415x_vender_code(struct bq2415x_device *bq)
> +{
> +	int ret = bq2415x_exec_command(bq, BQ2415X_VENDER_CODE);
> +	if (ret < 0)
> +		return 0;
> +	else /* convert to binary */
> +		return (ret & 0x1) + ((ret >> 1) & 0x1) * 10 + ((ret >> 2) & 0x1) * 100;

Just print it as hex?

> +static int bq2415x_set_weak_battery_voltage(struct bq2415x_device *bq, int mV)
> +{
> +	int val = mV/100 + (mV%100 > 0 ? 1 : 0) - 34;

This could probably be written more clearly?

> +static int bq2415x_get_charge_current_sense_voltage(struct bq2415x_device *bq)
> +{
> +	/* TODO */
> +	return -ENOSYS;
> +}

Just don't provide things that aren't there, the frameworks should do
appropriate handling.

> +static enum power_supply_property bq2415x_power_supply_props[] = {
> +	/* TODO */
> +	POWER_SUPPLY_PROP_STATUS,
> +	POWER_SUPPLY_PROP_MODEL_NAME,

TODO?

> +static int bq2415x_power_supply_set_mode(struct bq2415x_device *bq, enum bq2415x_mode mode)
> +{
> +	int ret = 0;
> +
> +	switch (mode) {
> +
> +		case BQ2415X_MODE_NONE: /* N/A */

CodingStyle for the indentation.

> +			if (mode == BQ2415X_MODE_NONE) {
> +				dev_info(bq->dev, "mode: N/A\n");
> +				ret = bq2415x_set_current_limit(bq, 100);
> +			} else if (mode == BQ2415X_MODE_HOST_CHARGER) {
> +				dev_info(bq->dev, "mode: Host/HUB charger\n");
> +				ret = bq2415x_set_current_limit(bq, 500);
> +			} else {
> +				dev_info(bq->dev, "mode: Dedicated charger\n");
> +				ret = bq2415x_set_current_limit(bq, 1800);
> +			}

This should be a switch statement.

> +		case BQ2415X_MODE_BOOST: /* Boost mode */
> +			dev_info(bq->dev, "mode: Boost\n");

Is dev_info() really appropriate for this stuff?

> +			break;
> +
> +	}

No default case?

> +static void bq2415x_power_supply_set_charger_type(int type, void *data)

> +	if (type == 0)
> +		bq->charger_mode = BQ2415X_MODE_NONE;
> +	else if (type == 1)
> +		bq->charger_mode = BQ2415X_MODE_HOST_CHARGER;
> +	else if (type == 2)
> +		bq->charger_mode = BQ2415X_MODE_DEDICATED_CHARGER;
> +	else
> +		return;

Switch statement.  I never understood why this is such a common idiom...

> +		switch (error) {
> +			case 0: /* No error */
> +				break;
> +			case 6: /* Timer expired */
> +				dev_info(bq->dev, "Timer expired\n");
> +				break;

Should we really be logging this at anything more than dev_dbg()?

> +			case 7: /* N/A */
> +				bq2415x_power_supply_error(bq, "Unknow error");
> +				return;

Typo: unknown.

> +			case 5: /* Termal shutdown (too hot) */
> +				bq2415x_power_supply_error(bq, "Termal shutdown (too hot)");

Typo: thermal.

> +static int bq2415x_power_supply_get_property(struct power_supply *psy, enum power_supply_property psp, union power_supply_propval *val)

CodingStyle - wrapping (lots of this in the driver.
