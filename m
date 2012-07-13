Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2GMTjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:39:39 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:47901 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2GMTjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=cUoo1t
	ksIHTWCBJvx25DUx26rJnciEqsaPgoorw2ADBpq4N0TFmF0DUFLx62R+AeTkqLLv
	bY5mXQtflw33a6/IZ/+aoeawbbeOVXIsGGwotoLYB9cXHdShE2U117Hj6roXI8Wv
	6dEkSyM0k6rZdwHwXvpJopjocIMIUIMGMu20c=
From: Junio C Hamano <gitster@pobox.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Marc Reilly <marc@cpdesign.com.au>, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        "Ying-Chun Liu \(PaulLiu\)" <paulliu@debian.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philippe =?utf-8?Q?R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        git@vger.kernel.org
Subject: Re: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx
 driver
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <11987916.rOoNGcb1ly@dev1> <20120713084854.GD592@pengutronix.de>
Date: Fri, 13 Jul 2012 12:39:34 -0700
In-Reply-To: <20120713084854.GD592@pengutronix.de> ("Uwe =?utf-8?Q?Kleine-?=
 =?utf-8?Q?K=C3=B6nig=22's?= message of "Fri, 13 Jul 2012 10:48:54 +0200")
Message-ID: <7vpq7z8n7t.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 7A45EA00-CD22-11E1-9CA0-01B42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König  <u.kleine-koenig@pengutronix.de> writes:

> It doesn't move it around, that's only how it looks. I removed enum
> mc13xxx_id (above MC13XXX_NUMREGS) and added struct mc13xxx_variant
> (below MC13XXX_NUMREGS). Git choosed to use the closing brace of enum
> mc13xxx_id and struct mc13xxx_variant respectively as context (together
> with the following empty line).
> (For the new readers, here is how git represented the relevant part:
>
>  #include <linux/regmap.h>
>  #include <linux/mfd/mc13xxx.h>
>
> -enum mc13xxx_id {
> -	MC13XXX_ID_MC13783,
> -	MC13XXX_ID_MC13892,
> -	MC13XXX_ID_INVALID,
> +#define MC13XXX_NUMREGS 0x3f
> +
> +struct mc13xxx;
> +
> +struct mc13xxx_variant {
> +	const char *name;
> +	void (*print_revision)(struct mc13xxx *mc13xxx, u32 revision);
>  };
>
> -#define MC13XXX_NUMREGS 0x3f
> +extern struct mc13xxx_variant
> +		mc13xxx_variant_mc13783,
> +		mc13xxx_variant_mc13892;
>
>  struct mc13xxx {
>  	struct regmap *regmap;
> ...
> )
>
> The following would be an equivalent and (for humans) easier to review
> patch:
>
>  #include <linux/regmap.h>
>  #include <linux/mfd/mc13xxx.h>
>
> -enum mc13xxx_id {
> -	MC13XXX_ID_MC13783,
> -	MC13XXX_ID_MC13892,
> -	MC13XXX_ID_INVALID,
> -};
> -
>  #define MC13XXX_NUMREGS 0x3f
>
> +struct mc13xxx;
> +
> +struct mc13xxx_variant {
> +	const char *name;
> +	void (*print_revision)(struct mc13xxx *mc13xxx, u32 revision);
> +};
> +
> +extern struct mc13xxx_variant
> +		mc13xxx_variant_mc13783,
> +		mc13xxx_variant_mc13892;
> +
>  struct mc13xxx {
>  	struct regmap *regmap;
> ...
>
> But as this touches 17 lines compared to only 15 using the way git
> choosed to represent patch 6, git used the smaller representation.

Yes.  Useful information bits per line count is the primary thing
our default xdiff based output pays attention to (e.g. we coalesce
two adjacent hunks that are one missing context line apart into one
larger hunk by removing the "@@ linenum @@" line from the beginning
of the latter hunk for this reason).

> Usually this metric is sane, but here it's not. I don't know if you can
> do anything about it? E.g. take the number of +, - and context blocks
> into account. Then it would be 5 for the patch above vs. 7 for the
> way git did it.
> Or weight a context line containing
>
> 	#define MC13XXX_NUMREGS 0x3f
>
> more than two lines one of which is empty and the other only contains a
> }?

"GNU diff" gives the same output as ours, and "git diff --patience"
gives more redundant (it wasts lines by removing "};" and then later
adding "};" back) output.  I think this is because "patience" pays
more attention to key off unique lines in the range (e.g. the line
"#define MC13XXX_NUMREGS 0x3f" appears only once in the preimage and
also in the postimage, so it must pair with each other).
