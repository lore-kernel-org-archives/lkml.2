Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab0HFFKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:10:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62453 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0HFFKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QWALsFEdXxAr3pCpA9jg788+B6DLfD0H7XH26amMATSkqjBidGE7OYjtcGOWzuTs3D
         OlQFvGWT8SUIeebI9KfW0eKPgOwNBAd2htKa0xCeAkh0/kEtzj7hKmk74k0VJjC+phIz
         wcbhGP0aC4psycv5qkHLY8KDWEYJeGT6NNsBw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 3/3] lib: vsprintf: added a put_dec() test and benchmark tool
Date: Fri, 6 Aug 2010 07:10:06 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com> <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com> <b3cd8c92d68f3ca7104be13841f1f66f7db9f7e1.1280872240.git.mina86@mina86.com>
In-Reply-To: <b3cd8c92d68f3ca7104be13841f1f66f7db9f7e1.1280872240.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008060710.06304.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
> This commit adds a test application for the put_dec() and
> family of functions that are used by the previous two commits.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

> +put-dec-test: put-dec-test.c
> +	exec $(CC) $(CFLAGS) -o $@ $<

(1) Why exec?
(2) Add -Wall, you'd be surprised


> +static uint64_t rand_64(void)
> +{
> +	uint64_t v = 0, m = 1;
> +	for (;;) {
> +		uint64_t n;
> +		v = m * rand();
> +		n = m + m * RAND_MAX;
> +		if (n < m)
> +			break;
> +		m = n;
> +	}
> +	return v;
> +}

What this function do? Looks cryptic. In my testing, it picks 0
quite often.


> +static char buf1[24];

Can you size the array safely, without assuming that long long
is no wider than 64 bits?


> +#define FUNC(func, outer, inner, correction, format, value) do {	\
> +		struct timeval start;					\
> +		unsigned i, o;						\
> +		for (i = (inner); i--; ) {				\
> +			typeof(value) v = (value);			\
> +			ret |= test(#func, func(buf1, v), format, v);	\

I'd add memset(buf1, 77, sizeof(buf1)) before test


> +int main(int argc, char **argv) {
> +	unsigned long iterations = 1000, i;
> +	struct timeval correction;
> +	int ret = 0;
> +
> +	srand(time(NULL));
> +
> +	if (argc > 1)
> +		iterations = atoi(argv[1]);
> +
> +	gettimeofday(&correction, NULL);
> +	for (i = 25000 * iterations; i; --i)
> +		rand_64();
> +	stop(NULL, &correction, NULL);

Why is this "correction" thing needed? I looked at the entire machinery
and I see no reason to have it.


> +	puts(">> Benchmarks:\n\tput_dec_full()");
> +	fflush(NULL);
> +
> +	FUNC(orig_put_dec_full, iterations, 100000, NULL, "%05u", i);

You have variable named i, you pass it as macro parameter,
but macro has local variable named i too.
Is it an International Obfuscated C Code Contest entry?


> +	FUNC(mod1_put_dec_full, iterations, 100000, NULL, "%05u", i);
> +	FUNC(mod3_put_dec_full, iterations, 100000, NULL, "%05u", i);
> +	FUNC(mod5_put_dec_full, iterations * 10, 10000, NULL, "%04u", i);

> +	puts("\tput_dec_trunc()");
> +	fflush(NULL);
> +
> +	FUNC(orig_put_dec_trunc, iterations, 100000, NULL, "%u", i);
> +	FUNC(mod1_put_dec_trunc, iterations, 100000, NULL, "%u", i);
> +	FUNC(mod3_put_dec_trunc, iterations, 100000, NULL, "%u", i);
> +	FUNC(mod5_put_dec_trunc, iterations * 10, 10000, NULL, "%u", i);
> +	FUNC(mod3_put_dec_8bit, iterations * 500, 256, NULL, "%u", i);

> +	puts("\n\tput_dec()");
> +	fflush(NULL);
> +
> +	FUNC(orig_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());

"%llu" fmt is for unsigned long long, not uint64_t.


> +	FUNC(mod1_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod2_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod3_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod4_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod5_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod6_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod7_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
> +	FUNC(mod8_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());

Here a lot of CPU time is taken by rand() calls. Also, you use different
values for different functions, which is wrong.


-- 
vda
