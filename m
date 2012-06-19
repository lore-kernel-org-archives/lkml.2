Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2FSHTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:19:48 -0400
Received: from hofr.at ([212.69.189.236]:55906 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2FSHTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:19:47 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2012 03:19:46 EDT
Date: Tue, 19 Jun 2012 09:09:07 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Tollerton <richard.tollerton@gmail.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>, linux-security-module@vger.kernel.org
Subject: Re: How do embedded linux-rt systems fill their entropy/randomness
	pools?
Message-ID: <20120619070907.GA9459@opentech.at>
References: <CAM7vvUeRQ0K5J-wtir4JmJcPRfFJtmvxn-yud16BG7KZupFNKg@mail.gmail.com> <alpine.LFD.2.02.1206182321070.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206182321070.3086@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Thomas Gleixner wrote:

<snip>
> 
> There are enough papers out there, which cover the inherent randomness
> of todays cpu systems, so go wild with finding the relevant points
> which can be abused to a stick some value into the pools fast
> path.
> 
> Thanks,
> 
> 	tglx

Here a quick shot of the current state of our ESRNG (Embarrasingly Simple Random Number Generator) - a trivial entropy extracter. There actually are not random number generators on this planet - they all just extract entropy from some poison process - but the name "generator" seems to be accepted.... this is unfortunately work stalled in progress - no more than prototype code and some early papers.

Here is a run on my current working box from this morning.

idle system:

hofrat@debian:/tmp$ time ./esrng -t 2 -c 4000 -r 5000 -j 9000 -q 0 -p 10000 -s 3 -l 1 -u 10000
min:1,max:22306,wsize:4216
r: 167347, d: 152621 N:7361 (data_int_10000_2t_jw10q0_c4000_r5000_N3000_j9000.3)
real    0m33.942s
user    0m8.141s
sys     0m7.708s
hofrat@debian:/tmp$ /home/hofrat/ESRNG/test_code/ent data_int_10000_2t_jw10q0_c4000_r5000_N3000_j9000.3
Entropy = 7.998823 bits per byte.

Optimum compression would reduce the size
of this 167347 byte file by 0 percent.

Chi square distribution for 167347 samples is 273.57, and randomly
would exceed this value 20.26 percent of the times.

Arithmetic mean value of data bytes is 127.2821 (127.5 = random).
Monte Carlo value for Pi is 3.136495644 (error 0.16 percent).
Serial correlation coefficient is 0.014924 (totally uncorrelated = 0.0).

so 5k/s on an idle system - note that the entropy extraction rate goes down on
loaded systems as the entropy extraction is proportional to the execution time
of the extratro so if it gets no CPU time then it extract little entropy - but
in general highly loaded systems have sufficient sources of entropy.

loaded system (io load)

hofrat@debian:/tmp$ time ./esrng -t 2 -c 4000 -r 5000 -j 9000 -q 0 -p 10000 -s 4 -l 1 -u 10000
min:1,max:39148,wsize:4218
r: 167931, d: 152037 N:7420 (data_int_10000_2t_jw10q0_c4000_r5000_N3000_j9000.4)real    0m34.505s
user    0m8.241s
sys     0m7.656s
hofrat@debian:/tmp$ uptime
 14:48:37 up 10 days, 15:17,  9 users,  load average: 8.46, 3.20, 1.17
hofrat@debian:/tmp$ /home/hofrat/ESRNG/test_code/ent data_int_10000_2t_jw10q0_c4000_r5000_N3000_j9000.4
Entropy = 7.998924 bits per byte.

Optimum compression would reduce the size
of this 167931 byte file by 0 percent.

Chi square distribution for 167931 samples is 250.41, and randomly
would exceed this value 56.93 percent of the times.

Arithmetic mean value of data bytes is 127.3719 (127.5 = random).
Monte Carlo value for Pi is 3.141346291 (error 0.01 percent).
Serial correlation coefficient is 0.019616 (totally uncorrelated = 0.0).

loaded system (CPU load of 16++ on a 8 core box)

hofrat@debian:/tmp$ time ./esrng -t 2 -c 4000 -r 5000 -j 9000 -q 0 -p 10000 -s 5 -l 1 -u 10000
wmove: 35870min:1,max:117000,wsize:63174
r: 28762, d: 291206 N:1 (data_int_10000_2t_jw10q0_c4000_r5000_N3000_j9000.5)
real    63m51.208s
user    43m53.533s
sys     81m43.550s
hofrat@debian:/tmp$ /home/hofrat/ESRNG/test_code/ent data_int_10000_2t_jw10q0_c4000_r5000_N3000_j9000.5
Entropy = 7.993978 bits per byte.

Optimum compression would reduce the size
of this 28762 byte file by 0 percent.

Chi square distribution for 28762 samples is 238.02, and randomly
would exceed this value 77.02 percent of the times.

Arithmetic mean value of data bytes is 127.2472 (127.5 = random).
Monte Carlo value for Pi is 3.129563947 (error 0.38 percent).
Serial correlation coefficient is 0.005237 (totally uncorrelated = 0.0).


Parameters:

the somewhat ugly list of arguments to esrng is due to the lack of 
autocalibration (a still unsolved issue really) and so this nees some manual
tuning. Keeping the extraction stable is done by the runtime control loop
(a windowing controler using the occurence of a race condition as the feedback
signal to adjust the loop length (statistical race "control") to race on)

Summary: on an idle MP system or io-loaded system a few kilobyte per second is
resonable - on UP this can be much less (on some embedded UP processors it can
go down to 100byte/s). for high CPU load it will fade more or less to 0 (it
is running with the lowest priority in the system in user-space at the moment)

If anybody has time to play with this and test it - I would be greatful for
input - works for me and if you have enough time (weeks...) to generate GB size
samples you can (provided the calibration was correct) pass the NIST test-suit
- atleast some of our data sets did pass - but at this point consider it 
insecure until proven otherwise. The test-outputs shown above are from ent
 (random.org test-suit). But if you have no RNG/entropy source at all I'm 
comfortable claiming this is better than nothing :) 

for those interested - just dumped the current state of ESRNG code (after
adding comments in the code) to http://www.opentech.at/papers/ESRNG.tar.bz2 

  have fun - get confused !

thx!
hofrat
