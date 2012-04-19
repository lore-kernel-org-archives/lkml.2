Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab2DSMch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:32:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19133 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2DSMcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:32:35 -0400
Date: Thu, 19 Apr 2012 15:33:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: volokh <my84@bk.ru>
Cc: volokh@telros.ru, devel@driverdev.osuosl.org,
        Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: Subject: [PATCH] [Trivial] Staging: go7007: wis-tw2804 upstyle
 to v4l2
Message-ID: <20120419123314.GP6498@mwanda>
References: <1334834777.9633.4.camel@VPir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334834777.9633.4.camel@VPir>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F900573.00FD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:26:17PM +0400, volokh wrote:
>  static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
>  {
> -	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
> +	int i;
> +
> +	for (i = 0; i < 10; i++)
> +		/*return */if (i2c_smbus_write_byte_data(client,
> +				reg|(channel<<6), value) < 0)
> +			return -1;
> +	return 0;
>  }

There are several style problems with this function.
1) Bogus comment doesn't add any information.
2) Multi-line indents get curly parens, for stlye reasons even
   though it's not needed for semantic reasons.
3) Preserve the return codes from lower levels.
4) Don't return -1.  -1 means -EPERM and this is not a permision
   issue.
5) Put spaces around math operators.  These were correct in the
   original code.

This function should look like:

static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
{
	int ret;
	int i;

	for (i = 0; i < 10; i++) {
		ret = i2c_smbus_write_byte_data(client,	reg | (channel << 6),
						value);
		if (ret)
			return ret;
	}
	return 0;
}

Now that the function is readable, why are we writing to the
register 10 times?

>  
> +/**static u8 read_reg(struct i2c_client *client, u8 reg, int channel)
> +{
> +  return i2c_smbus_read_byte_data(client,reg|(channel<<6));
> +}*/
> +

Bogus comment adds nothing.

>  static int write_regs(struct i2c_client *client, u8 *regs, int channel)
>  {
>  	int i;
>  
>  	for (i = 0; regs[i] != 0xff; i += 2)
> -		if (i2c_smbus_write_byte_data(client,
> -				regs[i] | (channel << 6), regs[i + 1]) < 0)
> +		if (i2c_smbus_write_byte_data(client
> +				, regs[i] | (channel << 6), regs[i + 1]) < 0)

The comma was in the correct place in the original code...  This
change is wrong.

>  			return -1;
>  	return 0;
>  }
>  
> -static int wis_tw2804_command(struct i2c_client *client,
> -				unsigned int cmd, void *arg)
> +static int wis_tw2804_command(
> +	struct i2c_client *client,
> +	unsigned int cmd,
> +	void *arg)

The style was correct in the original code.  This change is wrong.

>  {
> -	struct wis_tw2804 *dec = i2c_get_clientdata(client);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct wis_tw2804 *dec = to_state(sd);
> +	int *input;
> +
> +	printk(KERN_INFO"wis-tw2804: call command %d\n", cmd);

This seems like a very spammy printk().  :/  Put a space after the
KERN_INFO.

>  
>  	if (cmd == DECODER_SET_CHANNEL) {
> -		int *input = arg;

The input was better here, where it was declared originally.

> +		printk(KERN_INFO"wis-tw2804: DecoderSetChannel call command %d\n", cmd);
> +
> +		input = arg;
>  
>  		if (*input < 0 || *input > 3) {
> -			printk(KERN_ERR "wis-tw2804: channel %d is not "
> -					"between 0 and 3!\n", *input);
> +			printk(KERN_ERR"wis-tw2804: channel %d is not between 0 and 3!\n", *input);

These kinds of unrelated changes don't belong in a new feature
patch.  Cleanups, fixes, and features don't mix.  In this situation,
I would just leave it as is.  I know checkpatch.pl complains, but
it's up to the maintainer to decide what to do.  If you decide to
change it (in a separate patch) the format would be:

			printk(KERN_ERR
			       "wis-tw2804: channel %d is not between 0 and 3!\n",
			       *input);

When people submit big patches there is a lot to complain about and
they don't get merged.  I'm a hundred lines into the review and I
haven't even got to any changes which matter or are improvements.

regards,
dan carpenter


