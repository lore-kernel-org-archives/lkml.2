Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2FTT2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:28:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64569 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2FTT2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:28:12 -0400
References: <8495990E-0B78-4B47-A00D-36D45DC3450F@gmail.com> <CACRpkdZZmxqus6jujtq43qD_d_dHxi2wORmC18kGsD3aB1jjAQ@mail.gmail.com> <20120604091127.0f95a85c@archvile> <73B37CBF-9E2A-49F5-9CA9-8CFBEF3666D6@gmail.com> <20120620170126.311b8eef@archvile>
In-Reply-To: <20120620170126.311b8eef@archvile>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <9C01B236-B051-40D2-9805-F8B8F308827D@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
Subject: Re: gpio: pca953x: interrupt feature unreliable
Date: Wed, 20 Jun 2012 15:28:05 -0400
To: David Jander <david.jander@protonic.nl>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(putting Linus in CC 'cause I hear he enjoys interaction with hardware. As do I,
and this is a funny hard/soft timing issue, insignificant maybe in the large
scale of the kernel, but an interesting puzzle. Sorry if doing so is out-of-line.

It seems a few answers missed the lists, the interesting bits are quoted, and
should give a flavour of the discussion.)

On 2012-06-20, at 11:01 AM, David Jander wrote:
> 
> First of all: As a hardware designer, if you intended to connect this chip's
> nINT output to a PCA953x input, I assume you know what you are doing, and not
> just trust the features a particular driver advertises.

Of course, I found out about this while "proof of concept"ing chaining the
AD714X INT to a PCA9555. The product this goes in is not in production yet.
 
> Second: What I try to explain as a possible workaround for your case, is to
> move the complete ISR callback functionality into a thread. But since I don't
> know the details of your driver, I don't know if that is possible.
I trie not to modify the kernel wherever I can. For the "purist" part of me,
hacking a chip driver here to compensate the flaws of another there is not the
best way to do it. I would prefer fixing a chip's shortcomings in it's own
driver.


> 
>>> It still is an enormous advantage to have this functionality, because polling
>>> an I2C peripheral just to wait for input state can be a terrible waste of
>>> CPU-time ;-)
>> 
>> I totally respect this. However, it may be OK for a student project to have a
>> flaky interrupt controller, but for industrial or medical applications, the
>> interrupt controller must be reliable.
> 
> We use it in industrial applications, and we have no problems at all ;-)

If you examine the ASCII art of the timing I showed in the original message, you
will see that my particular timing is not the only problematic one... Can you
tell me how your 953x recovers from the state established at step 5? i.e. when
you clear the slave's INT through whatever mechanism, the 953x re-assert's it's
INT signal.

If I can attempt an answer: since the 953x has requested it's own ISR using
level-low, when the 953x's ISR thread is done, since the INT is still low, it
re-enters it's threaded ISR, and read it's input register again, which clears
953x's INT. (And this is key to the problem here, I hope you can see it, or I'm
mistaken here, but the ISR thread of the 953x runs a SECOND TIME) On this second
run, 953x's ISR examines the bits that changed since the last read, in this
case, two things can happen: (assuming your slave is trigger_falling) 1. Things
are quiet, the last read had your slave chip's INT low (and client's the nested
ISR was called (falling edge)), but this current read now says high. This is
considered like a rising and doesn't trigger calling the nested ISR again. All
is well then.  2. if for whatever reason (fast slave OR some delay scheduling
the 953x's ISR thread a second time) the second ISR run comes after the client's
chip re-asserting it's INT. This event makes the 953x's input the same as when
the input register was read on the first ISR thread run, so by definition, this
de-asserts the 953x's INT. When 953x finally reads the input register moments
later, there is no difference between old_stat and cur_stat and you are
essentially locked for this slave until you reset the whole thing.

Since the timings of the slave and the OS are factors here, it's quite hard to
reproduce. Even with the best intention and diligence at design, a race is
possible.


> Really, you must know what you are doing if you want to use an I2C I/O
> expander as interrupt chain controller!

After a good read of the specs and code, I had the idea to use our existing 9555
to separate the interrupts of two i2c slaves. I put this together on a bread
board and put the idea to the test. So I am in agreement that you must know what
you are doing when doing this. I had to know for sure before telling the
hardware guy to put this on real hardware.

>> For example, we are most likely going to
>> replace the 9555 in our next hardware rev because of this problem.
> 
> Then most probably you started your design committing a mistake. You should
> just assume your hardware design is flawed and not try to blame some driver
> for it.

Again, bread board. Plus, I hope you see that since we will most likely not be
using this combination of i2c devices, I no longer have any personal interest of
my own in this, other than my wish to improve the kernel in general.


> 
>> Remember though that I was proposing a fix instead of a complete removal (I
>> admit that suggesting removing the feature was a way to attract attention to the
>> problem ;) The only problem is that since we are most likely not keeping this
>> part in our design, putting effort into a fix of the pca953x.c driver is much
>> lower now in my priority list.
> 
> Ok, then what about just leaving it as it is now?

If you are comfortable with the scenario I demonstrated originally, plus the one
I mention in this message, or you can explain to me (and others) why I am wrong,
then by all means keep the driver as it is! I just thought, first the world should
know about this, and second, get feedback before attempting modifications, if I
ever do get there.


Cheers!