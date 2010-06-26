Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0FZMw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 08:52:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55334 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0FZMwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 08:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DLZirjiQYEky8mZpHEziSsdlWry8wH7uEmFibFEmRhfBDcmxeosJG/8Jx9DIylgv92
         opVI3jYYsOXKVMhz0Von92Vzh8rH1e314YcFYxvuPFrmp7xYDtC1MlbyPBA0X0aexI/A
         iSiyFXLdBYmLHTBfRbRMfD3uniVFgV0a/zI8c=
MIME-Version: 1.0
In-Reply-To: <4C251AFF.70803@colorfullife.com>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
	<20100621200118.GA4021@nb-core2.darkstar.lan>
	<4C223657.3030507@colorfullife.com>
	<AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com>
	<AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com>
	<4C251AFF.70803@colorfullife.com>
Date: Sat, 26 Jun 2010 14:52:22 +0200
Message-ID: <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
From: Luca Tettamanti <kronos.it@gmail.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Content-Type: multipart/mixed; boundary=001636498fd7d648010489ee5b83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636498fd7d648010489ee5b83
Content-Type: text/plain; charset=UTF-8

On Fri, Jun 25, 2010 at 11:09 PM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> On 06/24/2010 09:22 PM, Luca Tettamanti wrote:
>>
>> Argh, "seems" was indeed appropriate. Manfred your patch does
>> alleviate the problem but something is still wrong. I noticed (I'm
>> developing an ajax heavy web app) that sometimes an apache worker
>> hangs; I can reproduce the problem with ab (apache benchmark) and a
>> high concurrency level (I'm testing with 100 and 10k requests, and I
>> get only 2-5 dropped requests). This does not happen with 2.4.34.
>> Any idea on how I can debug this further?
>>
>>
>
> Are there still hung httpd processes?

They don't seem really hung as before, I see two different behaviours:
* Near the end of the run ab is frozen for a few seconds, but in the
end all requests are processed; however I see a few "length" errors,
meaning that the received page does not match the expected content
(I'm testing a static page):

Concurrency Level:      100
Time taken for tests:   14.682 seconds
Complete requests:      10000
Failed requests:        10
   (Connect: 0, Receive: 0, Length: 10, Exceptions: 0)
Write errors:           0
Total transferred:      79987946 bytes
HTML transferred:       77190466 bytes
Requests per second:    681.11 [#/sec] (mean)
Time per request:       146.819 [ms] (mean)
Time per request:       1.468 [ms] (mean, across all concurrent requests)
Transfer rate:          5320.36 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.4      0       3
Processing:     3   29 428.9     15   14678
Waiting:        0   15   1.3     15      19
Total:          5   30 429.0     16   14682
ERROR: The median and mean for the initial connection time are more
than twice the standard
       deviation apart. These results are NOT reliable.
Percentage of the requests served within a certain time (ms)
  50%     16
  66%     17
  75%     17
  80%     17
  90%     17
  95%     17
  98%     18
  99%     18
 100%  14682 (longest request)

strace on apache shows:
[pid  3787] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3789] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3788] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3784] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3783] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3782] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3239] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3233] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3238] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
[pid  3237] restart_syscall(<... resuming interrupted call ...>


* Sometimes ab pauses at the end but not all requests are successful; ab says:

apr_socket_recv: Connection timed out (110)
Total of 9932 requests completed

The problem seems more acute if there's other application running on
the system (e.g. right now I have kde, firefox, thunderbird active and
I see more errors; note that nothing is using much CPU time). I've
taken a sysrq-t log during one of ab pauses, it's attached.

Might be related: KDE (4.4) takes an usual amount of time to start up:
the splash screen is fronzen for a while on the screen before the
desktop is available (.xsession-error does not show anything
interesting).

Luca
PS: I'll be offline until Monday 5th...

--001636498fd7d648010489ee5b83
Content-Type: application/x-gzip; name="sysrq-t.txt.gz"
Content-Disposition: attachment; filename="sysrq-t.txt.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gawg91n40

H4sICID3JUwCA3N5c3JxLXQudHh0AOxd247jOHO+z1P4PkgiUiRF/QiSizxCcrf4IVA8zBjTbXt9
2Jl5+/Agu022R2zaLXk9rgZ2BxBUdEni97FOLP6xwJxW/942FDPyz8XC2D/Oq0pgxHpB+aKK/jhL
LqgqFjGK/8sfvxyzalXD30ucj4lwa+84/wli/3s35phEuHD8EW6kaamu3qmRjvk/4uVl8X9bIfU/
3v3cH/9phj+OKtz0rf6vfy7+eyG/avmt22y1ft3su+/imz5s/rX6Ydh/VD8QM6PD4EazprXD7Owo
6vCiu6/b/fJVrw/7bitWX3QnX9bymx2uVm64SmaGU7pqvVZd93rY6x+dE+92L+vvG7H/asfBrLUD
4RaND8StZtwPtDv0p4eT68NqbwdpsR1DsMwbkkwzP8QXve82YqtX+27pXg1CVpyg3JtpKBt5M3Yc
7V/JuBa9ZAbbYTbrl5fuNNYwkh2D1HYQanKD9EjaQdS62/3cdW4s90kapwCp2oywapkZvomT/C6W
7ocrKyubnKiowysMgt/0IEjxqCCqlBZV+HxaHrbL/c/OLO1zb/T2dbnbLder42dAde7RFUPuM7w9
N3Ua9GJcrsIt64PcXr920uKqM2K3H6Yh8ujo0zGWUqv1X/rf+uVqsVj87xHQdriq7VFFFwuKamb/
zzFZuH9Qu7BvZPj7NelIwdBFIjvecfyLRXJEJnr5XmIyIgtvlmFS4eqdGtcSmcMZoh9hINV+gIEq
0ps+8GIYZ/vGiG7aYJQRl5KaSHy3F9ujKqudI1anBpDHTeSxE1/0Yqs3Wuy1WvCFe6Td+HAUVY30
w31zd3eO1Pfuewj1ATqwb7IlJ2W6nX7Rcm//2Z+9Teb4qJEPw0dC1ouFg6PnI1rAR3VjVCNRCR95
kRwf8UsS8/MRvzDmhw0rynom7Icy3nxx873786APunt181e6b60yiKNNz000hPvCtQMrVtUD8FdF
ea9w4Az/EFaMO7kWk8nttsp+0GA7OMZaflkJDzLhEGJBnBGuMQmvT2yWsguvYLna6+32sNkPtIsz
34C2tJUDxo+Pj2rq3htROeUbEljKCdsXbx9gq/eHrTd4jLd9sZqDKt7MAi54bW2PN6pgRaZLy9Ao
VYQ7Kh5fGKUKp1Js7LTTmi6XPb9BDaCKe1BFJXTVmBPOf65k9906Cv7N+Rle1dNTzZ3ZQmjBAlv8
ZXanx7cehhfWOeGeNieqOQpT9+6ZnNkYaYykzi3Czi2ivMYlDIMxMhcZpkr+YpFxYwSzixJzGyNB
jeujPDfFMO5MUJ+B0HuxC6B6CHnIxYIwj21OaJHd0FNUiGonkrMbkhU8SExpN6DaSC6RqN6p8Zyo
vln7eyFaGNyHEIBxir8sv3x1Ty3cGq/wtM8MZFLRmkv25oSQIicEV6rYRLAiuXhFDOtBYv54hVPj
Scnkaja4HyKxbBsRQHWKyIqli1Hg3gUCq7mBxVRlLJZI61dpisqA1ddlgUAvkrO9SQIsLzG/7U2e
FlifYHvjxlCJQ+x/K753u81y1R1WQzYG+RBDn3sHsg+hvOMj+CSAckuu+Zsyg0aN6L24e1LLDvbV
dcNDE+EGyCy6GhOfIbAPLVd7l2vYvzhhrBy9YK0mY6a+R+ptufe/7pZ7LF3Spc7aCorjt8ilFuqO
fod1PN5MBVoWTahQU8xoqMkxGkqqN1BzF0ZzakC88hHjlc/rBJzPXyrUWSaC4bKkpTSjyA53nGUi
/IUcsul5ROEoMXc1WFADkA3IflBkcxUjuy5AtsUDGs8xhjvOkO0vZJDNo1jhUWLaWKFmNPF9ghqA
bED2w2YBhOzPkF1W+MhVaXzBiYwjGyl+SWLmLMCgBiD7IZENEf1PJ4ai9CCuDSp1061IzpjHUUX0
IDE3MQQ1gBhgyX9cZKNzZDdlxjwtXPK9yDiy6yZymI8ScwfgghqA7IdENlT7fR49CPFGD01ZFE8b
Wrr1wIrk6EHFUbwgMT89gK8PC/+Dm/Rnm4qaumynQCY+f8HXb3PxeaSS2rtW3qNIJ6gByAZkPyyy
e4zPkE0KK/RVqbNuRXJrNr8kMbezHtQAZAOyf48wXFNWpc9JXxyfJ32mSr8nSb086e9Rpd8TWLMB
2Q+NbHZWB9cU7tutVLE1XqmcNZ7svwkS82fewM8GZD8ysinn1hqntcM0Q4gUBdi1MqUBdj2+GYaT
Rl2UmBfZRzUA2fdANjJt1Q/NK1zXNqV3++36Z7dcrZV7fbV7hjrDDnZi8oEdEnHsiufrXLMipRQa
+g0pX3vvyu7dvhqSlbS8FH74KFe7XQ6EZxQm0oR6/9fVfnPYd6t1p39slluvM7EjTFixPzmxlDgD
nLgWS2XE4kRyxEJiiAeJ+YkFnAEgFiCWUWLZrzeLt7/EF+GtWixI4zwS2rY+M1Czj+7JsU/ynlhw
csd5DyF3YZxYTJ/0cQ0ScxNLUAPaH/5t2x+qmrCh/aHv+ue3xLmfp8z87TqnXi/YaDr0R9zoren0
X66gcS9238Kb68Irww74dZVpVmgd7CpsHhVb+bXb6s3aToJX/bpcmbV78a5EkqlJKyxvbN/7Oftf
2+bi/tduuf1za1ehtedyhP0SnuvXTLgY5pL7qp3HZG0+sJA8+ou0c5oq1xVa2vfle5CegIgp9kv/
+MtDfa+Gyp39/mf3opY7aY2IrTZOA7fnPiPOZM1P4su19Pti7XpmRXmfa/jZE9KeYg5HYexkBZq0
ZalqSTOs/qcXJpzdICcJV4iNsESBT4v/2xLHeOUbCFLi2nuxyocrSM3Yx7wK1hipxzb3+DsYjy+M
L/6MJ35IkJh82168pWhQ49rFH1Wsams/QZYbedpk7iDB6ZSgRhXv+/o0t17d7FRrJ819e/bWiFws
DQ2bxY8xwGHD+MdCgLebxkIKQcMm++XLxhlJOyfL6vzCZB9eEfP28P65nSMwiUm9Oywik/rMDyah
LSfxBXTMWvvepObNBzuK90bT0bac7g7C4wvjqLIqJT3I++mDgMr6lUlMgdyUkr9xvawbgXkwGI9O
OvffNgeKuulrOswrJ0nc6uSXJ5k1NJj4paFx1BtnWL9mWNHhRIjliwpBCjdLe+F5xRuR9RRzvBe7
r5fnuKBhWyhtfDyq8pXkfqp/bMO3VqNz3N+hJI8vjM9xq1Ky4VuryVvPSt4n61VQ4+Hm+A3W0NPC
40Xvdr+KqtiVlvl4CvbhWr4YUPKhPJAxVJqRqMqFPJAxNBeuRfFGC3OHSuqjGtdHVRTt8XkA4i1o
4D1gJDPRxtqgJhg4++3Pbr+27sbLsGPAmTvOUnKmBs9EEKxZioKhY14Ou69uFPHTOuPf11s35xrX
mYdXGe+lRcL1LVx1zns5Nubxj8H59M5bjTRBQ9zViMNLOGKoM4eV3IdzXBxyTOYZSMudA3f2BP7Z
ZZWzM2Xl5BzZDHJC+Phnn+1mxPhANoMgoZNlekW/+HXctK1dT2TmajgYqn2mt2qbjy2Ayr59VIJw
LzKK8NSJOUrMjPBBjTstgJYgGr8AXiAI1MqPMQTGITq02a6lpfizIapsTKJSsvVhSTdBtQ9wHhfi
1rcJ4/30sLzFi/qkIEOMlLZ3PcQHpNCSIIP9V10IMmTWwlFT0QKj55ck5kXKUY35gwy3Rgk+Y/UR
vCJsCJvuXkR/zMCpxsUNpz0C7tYox90Sh593/Nq8sZJRchDENTltgqFcNwXkIGTfNmXk4EVy6cek
3DhIzG0oBzWAHIAcnowcziHQtjU/IwdeZDlIosbTE/4OxuMLOXJI2xWQOYJM4l1twi3tCh42PQHc
AtzyiV6Jcl4JQ76gsm6LUp9ItYVeiRPJcQu/JDG/4QFeySOSwxPlXsdh3XhY+4oG5EIOH/cncI3r
Qn/CieRgLZLeZbi+SznjLac5A6xhzf8tgg0+K8cq7skBFa35XBav+VYkd+5ZRA5HifnPPQNygDX/
odb880YfwqCzMAHBRWEC1Y/DOtwRhQnshVwLlBjWg8TExyBbfyE+fCCoAWECMBnAZLjeZKiVP1w9
+BN1EbdohUqTl1Ykxy2xZT9IzN9eCfITQA5PnJ9wtZ/h1KMTOZRtn5ANGs1PHJEYi+Q6NNF4I0OQ
mDc/cVQDyAHI4YnJAUXJS1JU9kR6k/FK/B3R3ip7IUcOcQnwIDHt3qqqrZLWUkEN8EqAW4BbruAW
hOu+wj7iwRALgUxWxC1aoAy3uDsibrEXRrglqBQHMoPExIeyKXmeMj2pAdwC3ALc8jkVmaQp4hbR
fsipqWKRXHPKJEkSJOZvFQ9JEiCHZ3ZqXIbBOzUnw6OsItPUGcPD3xGlWkydJYekItPUc0Q84jjL
UQ0wPIBbgFuuMDzegp1v0dSyikyOc06NuyNyauyFMacmdS9OEhOnWpoo1XJSA7gFuAW45ZqAiUNQ
bLfQqmwnSd9k7BZ3R7yTpG9y3JLuJOmbyYOxhPHzMM1JDeCWK7gF2OE3tTxoWV0ok02uDZ5skjZ4
ssm1wUvCqUFiVsvjpAawA7DD8+5CZTxUeZxsh6LyUlLVGdvB3xGxg+tdlmGHpMojSExuO5CUHe5T
5QF+CXDL78IthJizCjJal1WQ6Ry3uDsibrEXctySoDxITMotrhVOkuIJagC3ALcAt1zLLSiOeZRV
p/Yq59W4O+ICNJXllrQATU3v1WhWveMWKEADr+a52QGRJCJaVp4q+hw7iCQi6i7kmpTHEdFBYmKv
RrxvUg4RUbA8gFtu4RYVR0zKylMbmuMWd0fELfZCjluSAz6CxMQHINA6YbSgBnALcAtwy3WZXGvM
h83+x4hJWXmqyUZMTBoxMTqTyX3nXxg9g90SM9pJDeAW4Bbgluubh7H6zG7hZdzSNqWl76Yd55b3
FoRpZz9k+aQGlL4DOTytUyNoONXtRA5tWem7ypWQmSSc6i7kTrxKjzGYPJx6qRlxUAMMD+AW4Jbr
99yx9m3PHavKAiao2PCwIjluSVAeJOZuRhzUAMMDGhM+aDNiRt9iFaywrhQ1pf1GWR7WiT/BUHOH
ZsRBDYA1rPlPHWww+GzNLysrzfkTl4INeX8iDWSq+5AD7LOHNf+R13x2tuaXVXSqphjWViTTMJQn
a36QmL1hKIc1H9Z8SDCwszW/rCQT1cV+Pqqz5JCs+ai+DznAmg/k8NS9dWoeqqZO5FB4TnKuasrf
EScYaJYc4qqpQWLmbsKDGpBggHrt504RNP7soiawAyvrYKHbQtPBieTYITmIIEjMbzo8b4oAHP57
FyQaZYY+30eHv6wgUYlcn293R1SQaC+MFg05lRKHX0zf55s0Km4tM6gByza4BLDoX1dzRJGI+nyz
soJEKXPc4u6It4fLzCHFVqU4XiAnP7Dw0vbwoAZwC7gEz8wO8RZOVtYwk1RtZpuVuyNiB3shxw5J
qiFITHzuIU4ziEGNp2MHgPbvA20Z9YVpygoCqc4t/O6OCNpUZ6GdgkzfZ+GX0BcGnArglpuSkE3v
IomIeW4pq0rUvPgUdCuS4xZ+SWLuwqOgBiQhofDoAU9BxzyOFTRl9YQiGysQaaxAyEyCAKe1BULO
EIdMIhRHNcBkAJMBTIZruaWNchxNWVFjy3ORBndHxC0tz3JLEmloZzAZpJ1UTRJ6gGZRwC3ALbfv
fTzZLWU1kZSXFjY4kRy3pI7BtNzyi/MGMYe9j0AOQA7n5FDWpZKXxyp4LlYRlzmcJObeGB3UAHIA
cnhqcuDkLJBZeAq6LLYctMySQ3Iwh5b3IYf7HMwB5ACBzFsLKp2PHXWPbcoKKptssKFJgw0NHy+o
TN3+o8TEgcw6yoqc1IBgA5gMYDJc1z22F3H32KasoLLKJkmqNElSyXFucSrF/kQ1f0HlSQ3gFrA4
nqxnw9n5nyeLo6yQUvJsmXVqcciMxWE/YeJIyDkqIt6dPC4UnPAHFgdYHJ8XweRllZyYotIghRUZ
D1Jgwi9JzB2kCGrAvk2A9wMXamMSV0bwsmJKg03uOAp7R3wcBTY5eKct473E5FVXSc4UwzFaYDoA
t9zELXFFJy/sEMmy3MJSbmFZbkk7RLLpucXoOjVxyFMGKwDavw+0w/6uE7TLCip11mzQqdmg82ZD
soDryc2GS60qghpgNoDZANxyLbfE+VNeVlCpL5oNLLkj5pa82ZDkTzUzM5z7TUnqkkD+FLgFuOVq
bnGWuD8E6xTuKOtRmbVbTGq3mJzd8s45MNPbLRe2tg1qALdAMPSpcx09qiw7kFCQycsKMnvU2E/5
nh2SRG0Vi+TYIfEv+nscYzWocS073IgQ3KgGO4zu7HdTBzvDHMrXBwdQ1Er3kSUZV6A2GAeQbLZr
qXe7syEqO0A/Lq5k660HNz/1Zm2n2XexDD9PrTTmGfkaaYICRrURh5e9lf+mO3NYyX2AiVPCTFao
MME6ikMd0lC6zMtqHHuaO8W6T3o9uws5pCT7Gvrpez3zSjCcrqMY6pCgDulZz44R7ujHk+deVp2I
2+KzY3CbZYXUh27vcCTUoAbUCoB5/NDOMw0HPBwX/bIyQ6wyBzz4O6JFH6ssvJMyQzz9CdLcSJMc
KxHUeL58Hiyat4e7a8SjkFRbVmBXo5wp7e6IUFXnDlmt03ZmNZoeVe9z8zWCc9kh3A0r9m2tEkXt
uCWs2G1ZdV9NTalBbkVy3JJU9wWJuVsl1ggOcwQ/+4HPaA2wHkyGssK6ujWlNflWJAfrdPFu7wNr
OIYRYP3A4TMl345Ia8uK6mpVDmuVhXUKMHUfWEMnMYD1wzr4w7mox9W6qJ6tkihTc+LvOHfw3YUc
rOMA1iAxuYP/DtZQzwYOPjj4V3NLJflQz3Y0GWgZtzQqxy32jphbGjXKLU6lyMgYJCbmFkFjbhnU
AG4BiwMciZaVsYIs7Tpa5Y5dtHCM69iq6Y9dvOBIDGqAIwGwflBYG3QG66Kiu0pVxbBWVRbWcfnb
IDE/rB+zmTCg6u/TPOvknpcUrQlsvZlRVIU7zkxofyGHqqho7SgxMaq0bJMlmhPYygpr7TMG7Spd
D31xWOVKWXFVlDmvdNuP17r5OyLH2l4YZwWrUozPIDHzAaaDGtC7AkB5FwO4VicDGFe4DJSqL0yQ
OZEcKFN4qP4OBnBQA/xaWGsfFNbOlz3BuixBZlhdCmsrkoN1kiALEjNvuxzUAL8WUHXdZmaMz1BV
lhoyoha0LFpkRcZRZQS/JDH3YhnUuBZVdsFqED3fjfx1O2wm7rZi9UW72eKRplo/WeX4dye96bWf
amGcrd8bfNgMm4JxBipESmoi8d1ebI+qrHZ2GOPUQNmHomzkoeww2j9NJrUrmXHA9XukL2zXJg5A
1OQG6ZG0g3js7zo3lksRN04BUrW55HLLzGANOMlho7Z7lbLJiYo6kFYQ/KYHQYqnNmKQkXIgnJ2d
PFb29XW9sqwn/3rdfXFP71iLZFlbqvAA73i75fIDvI1My1nzpoZYro/Mi4jb6Y6oyhK/UReJH/PJ
id+qT0TA0uv6L90Jpbbdft0ddnprx2icBm3GHqSoaqQf4pt7e517jL1DkVCuT4DIzv+WnKaQ/QQv
Wu7tP/szDDC3AjYyN5BiaFhEBgDQ6gMKTLCK4JrZVaRpwypStKXXmmH9hVVk1DazIrlVJOHzIDH/
KnJLTSKsIrCKfG6TlE/wpP1e1sHqXakuqOG/GnfkL6Y1+m8U5xVW4fkPKwedo+rYPTnOfLS2rno8
fG87YXyPFjfRlFt2aQ58LSFMBPSIlbJT9fX1bQjqbH/emikXPvfxUXsUdw9++v1aUf/yMKyc82YQ
2ira14tR0b7eqkUok0Fwd0QZBHthfOVsq8T/ChKT75ZP8hZBDcgrQqzzOWOdWr7Z06gsr9hePE5n
NCrT0iwrpPi8x3E6gxqQwgBYP/6OXIzqMlgrWgxrRXOwThzWIDG3mxzUAFgDrB+wCqithq17Qw4F
lWUmBaIZG97dEdnw9kIO1klmMkhM3C66bt7BGrbuASs8JysINmy6O9rwZZlVQXOb7twdMSvQTMWw
VSk2D4LEtKwgeRqJD2oAKwArPP0h3BiVbbqzz5+zFURqKwiaY4Vk012QmPUQ7pMawArACs9oKxwb
5Q8eRNmePaFpzlbQKSvoLCske/aCxOSN8lMLhUGjfGCFZ2UF4o/PPIULy6pqepKzFdwdESvYCzlW
iBvlDxKTs0JqoTDYcwis8NzHZwz99TFqy1iBFycRrEiOFeL++oPE3EmEoAYkEQDWDwLrH+eQkfFW
YlyW8icI6T6FNWHJHTWPL4zDuk+3+pMZCoFcgVhCP7K936lyVc1JjUOBqP7hyzuZcaBuKp4V9KRg
Bb9s14fNUbxxcG5FVlir41FyVi4M4XR20ojNa4j2Upyf44Zx2Y5aQtFoeXe4g/D4Qm5uJjtqCZ2h
SC09SGZQA8q7obz7kzYJ2aWMDCW6+q/uz4M+6O7H6zLUCLsKWdJmXr87yMUMZkxnlqvl7mtn39jG
vzTcui+INc2NwQeDxI5xElbujSv9N69Pt8pXAwqs8tEbtM/trCHW5qqcqdLx9qbv2+X++AkRGT9G
FLszaoL8Xm66vZ30O/v73e5b71YPSfzqkZkHhIi6P43hf/74FBw5m46bJjOTsO6Ps9fy0VoOCtRu
FiHMJt2hdaM4FIm/qxv7//aupUdSGwj/FaS9JFKa9dtmDjntIXvYKNpIuUQRooHuJUNDh8c88utT
hl4NDTY0rJbNJLRGmmnwZ5fLLtdXdg1E+5ftYTIvbwyWjLkhH0Cm/G8v+GoRa6eDtmJsId8W8r3m
nZxLhgiZlzfGIjz3iRYAmTLrXt5Yi1h7J6cVYzPrzaxfqVnvo060PC/xi2Nv7iM1ADJu1oM9lRax
trduxdii5S1a3h6psT1SY4v5xvZcOcbtecDl8J/MSxTkxvRh0StxdfjPp9KHQaTr8wDOV3hnR//l
YhcxtsP/jVv+P7llEHROCeelBPHD7GebAmRqVeilBLWI9bkle5U7QZtVfftEO4559917hMxLqRF0
P5F+q0tc+Vq4MGVVvZPGFrH2v+q0Ymy+dvO1/9VV4VcdKzvv4n19dH6LC/12vzvnAbnI+8EhrnAp
3xUh3UVJUT07bwgfRMFZ/ugElb6GERaupISB7Z/KOCwH8jrun8nhkMSlM/W5cxjxwMtzRImhGuhj
WF0CfT8NqjgLn83VYOJaFrBeLack849FkNVpoF952BPmxkraHRRjPXfOrZKEn5I08os6K/1DUpTV
lSToxkoOcVDVhVHToBTOJJ6qoaqzYJ/G8C1Ik+zYq8H5Ls2PuoenJPy+X1X/e3iu3yCYT9hjMEGY
8+Gnvw2tZ4XudNZrq6M/AybNg2hsFhFkeF9m01T5mFTQT7OCiJAEE25G6jb9+hzBtCsHSErBZzAz
sIa+VXFR1OcqAc1eA00jmsVPlb8P0iALY5uNuNpIjKMZ1kWx+/GcRBbdUImkCab91JhKoTwUd6G8
J0xSw2g3Ovod/WGefYiwMRg2w6RQYyhiRjE2iqJmlGGd66KYpWOeCfUMxtx4Tos+FTVJ2NpgO0lN
KGTF2NqCXknOgN1Zkcc8iVLjRFOwpjMTMHg4+mbQ57G2rVZV9Vjb9QJIEBV+bEiYpEFqUSgmGJlG
Yn+fjo4EI8MN18FSdij94i+Y2neGBuKnOPSt9gMNKAqKdKnnKWIS8MP7n/0HWAM1XzNaLFAqxl0o
L42Wp33YFJ7jEXzw9EXtl2dNs+xLx5jzaqBoCXRlv9EI6ucPcWGYtFRMTSB9RGKbP3BvpDNmowdM
9anIqyqNI2cGxjjEHWUrQS1Q6wTRUI/bRmqgCOimJhhOFZT3pUEdLx9dAn798v7dyyWIJnb3MfCr
F0d+LpK8uantcNcXs6xPO32j+71M4/jcb3m32sfY5/s8i+JTkEVvwRqIR/T/wl5bnr4AoatHcfMH
MhaAOx4VrsKcKn0BYjqqCHYZF5gP6MLHjrb3QQkuR7ODzxVL6WJPQix7KaG4vG65VwACX+AlVKlG
QsI88IzC9ThDQtzCFfEXc0W8wOYtvGSSK0pBKMFLuCLjivK1uSKlC7giV4ot44oQFUq9nGAu1uOK
mCi0gCxiJMUCtijFErbIjUM/xRZBIavRRcWJ8tACuugh0KRcly5CEMQUWkIXGWKSL6CLhDJ5I13E
i+giJ5xxoo1WoSV08eKJ8RKmSIj0iMuBg0u2gCmONP0VSSJWmGEXUS4x+/ZOY5wo8tuIIv7XE0XL
WG1E8SsSxY/ntD4m2S7MsypIsthpHHTDxrqG24jPdXJJh64NCkhgZcKVCGrWx6mOpwBCXSkocLrB
4PwDaf9iQO7lAQA=
--001636498fd7d648010489ee5b83--
