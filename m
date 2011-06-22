Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab1FVOZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:25:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757743Ab1FVOZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:25:36 -0400
Message-ID: <4E01FBC9.3020009@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:27:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 0/22] KVM: optimize for MMIO handled
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:24:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:24:56
Content-Type: multipart/mixed;
 boundary="------------010404000102090100050103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------010404000102090100050103
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

In this version, we fix the bugs in the v1:
- fix broken read emulation spans a page boundary
- fix invalid spte point is got if we walk shadow page table
  out of the mmu lock

And, we also introduce some rules to modify spte in this version,
then it does not need to atomically clear/set spte on x86_32 host
anymore, the performance report of x86_32 host is in the later section

Avi,

I have sampled the operation of lockless shadow page walking as below steps:
- mark walk_shadow_page_get_mmio_spte as 'noinline'
- do the netperf test, the client is on the guest(NIC is e1000) and the server
  is on the host, it can generate large press of mmio access
- using perf to sample it, and the result of 'perf report' is attached

The ratio of walk_shadow_page_get_mmio_spte is 0.09%, the ratio of handle_ept_misconfig
is 0.11%, the ratio of handle_mmio_page_fault_common is 0.07%

I think it is acceptable, your opinion? 

The structure of this patchset:
- Patch 1 ~ patch 3, fix the bugs in KVM
- Patch 4 ~ patch 7, cleanup read/write emulation and cache mmio info for them
  to quickly mmio emulate
- Patch 8 ~ patch 13, cleanup/prepare for mmio page fault support
- Patch 14 ~ patch 18, optimize for spte operation for x86_32 host
- Patch 19 ~ patch 22, implement mmio page fault

Performance report on X86_32 host:

Netperf (TCP_RR, NIC=e1000):
===========================
ept is enabled:

      Before         After
1st   677.28         697.58
2nd   670.93         703.94
3rd   677.19         692.17

ept is disabled

      Before         After
1st   648.06         725.54
2nd   644.71         729.56
3rd   650.80         724.67

Kernbech (do not redirect the output)
==========================
ept is enabled:

      Before         After
1st   1m29.525s      1m26.904s
2nd   1m27.101s      1m26.423s
3rd   1m25.552s      1m26.070s

ept is disabled

      Before         After
1st   3m15.126s      3m11.754s
2nd   3m16.090s      3m10.382s
3rd   3m14.428s      3m9.056s

By the way, you can find the performance report of x86_64 host in the
v1 version:
https://lkml.org/lkml/2011/6/7/190

--------------010404000102090100050103
Content-Type: text/plain;
 name="netperf-log"
Content-Disposition: attachment;
 filename="netperf-log"
Content-Transfer-Encoding: quoted-printable

# Events: 97K cycles=0A#=0A# Overhead   Command                 Shared Obje=
ct                                      Symbol=0A# ........  ........  ....=
........................  ..........................................=0A#=0A=
    11.50%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Flock=5Facquir=
e=0A     3.18%  qemu-kvm  qemu-kvm                      [.] 0x2ef61        =
 =0A     2.90%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=5F=
save=5Fflags=0A     2.68%  qemu-kvm  [kernel.kallsyms]             [k] arch=
=5Flocal=5Firq=5Frestore=0A     2.57%  qemu-kvm  [kernel.kallsyms]         =
    [k] lock=5Frelease=0A     2.28%  qemu-kvm  [kernel.kallsyms]           =
  [k] check=5Fchain=5Fkey=0A     2.25%  qemu-kvm  [kernel.kallsyms]        =
     [k] trace=5Fhardirqs=5Foff=5Fcaller=0A     2.14%  qemu-kvm  [kernel.ka=
llsyms]             [k] hlock=5Fclass=0A     2.01%  qemu-kvm  [kernel.kalls=
yms]             [k] check=5Fflags=0A     2.00%  qemu-kvm  [kernel.kallsyms=
]             [k] native=5Fread=5Ftsc=0A     1.82%  qemu-kvm  [kernel.kalls=
yms]             [k] look=5Fup=5Flock=5Fclass=0A     1.80%  qemu-kvm  [kern=
el.kallsyms]             [k] mark=5Flock=0A     1.67%  qemu-kvm  [kernel.ka=
llsyms]             [k] lock=5Facquire=0A     1.63%  qemu-kvm  [kernel.kall=
syms]             [k] arch=5Flocal=5Firq=5Frestore=0A     1.56%  qemu-kvm  =
[kernel.kallsyms]             [k] lock=5Fis=5Fheld=0A     1.55%  qemu-kvm  =
[kernel.kallsyms]             [k] match=5Fheld=5Flock=0A     1.48%  qemu-kv=
m  [kvm=5Fintel]                   [k] vmx=5Fvcpu=5Frun=0A     1.30%  qemu-=
kvm  [kvm]                         [k] paging64=5Fwalk=5Faddr=5Fgeneric=0A =
    1.23%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=5Firq=
=5Fsave=0A     1.19%  qemu-kvm  [kernel.kallsyms]             [k] local=5Fc=
lock=0A     1.12%  qemu-kvm  [kernel.kallsyms]             [k] lock=5Frelea=
se=5Fholdtime.part.7=0A     1.08%  qemu-kvm  [kernel.kallsyms]             =
[k] native=5Fwrite=5Fmsr=5Fsafe=0A     0.90%  qemu-kvm  [kernel.kallsyms]  =
           [k] lock=5Ftime=5Finc=0A     0.89%  qemu-kvm  [kernel.kallsyms] =
            [k] trace=5Fhardirqs=5Foff=0A     0.88%  qemu-kvm  [kernel.kall=
syms]             [k] lock=5Facquired=0A     0.85%  qemu-kvm  [kernel.kalls=
yms]             [k] trace=5Fhardirqs=5Fon=5Fcaller=0A     0.84%  qemu-kvm =
 [kernel.kallsyms]             [k] arch=5Flocal=5Fsave=5Fflags=0A     0.81%=
  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fcycles=5F2=5Fns=0A     =
0.79%  qemu-kvm  [kernel.kallsyms]             [k] sched=5Fclock=5Fcpu=0A  =
   0.71%  qemu-kvm  [kvm]                         [k] kvm=5Farch=5Fvcpu=5Fi=
octl=5Frun=0A     0.71%  qemu-kvm  [kernel.kallsyms]             [k] arch=
=5Flocal=5Firq=5Fsave=0A     0.70%  qemu-kvm  [kernel.kallsyms]            =
 [k] mark=5Fheld=5Flocks=0A     0.67%  qemu-kvm  [kvm]                     =
    [k] x86=5Fdecode=5Finsn=0A     0.63%  qemu-kvm  [kernel.kallsyms]      =
       [k] native=5Fsched=5Fclock=0A     0.61%  qemu-kvm  [kernel.kallsyms]=
             [k] lock=5Frelease=5Fnon=5Fnested=0A     0.60%  qemu-kvm  [kvm=
]                         [k] x86=5Femulate=5Finsn=0A     0.57%  qemu-kvm  =
[kernel.kallsyms]             [k] system=5Fcall=0A     0.56%  qemu-kvm  [ke=
rnel.kallsyms]             [k] debug=5Flockdep=5Frcu=5Fenabled=0A     0.51%=
  qemu-kvm  [kernel.kallsyms]             [k] hpet=5Fnext=5Fevent=0A     0.=
48%  qemu-kvm  [kernel.kallsyms]             [k] try=5Fto=5Fwake=5Fup=0A   =
  0.45%  qemu-kvm  [kernel.kallsyms]             [k] effective=5Fload=0A   =
  0.42%  qemu-kvm  [kernel.kallsyms]             [k] might=5Ffault=0A     0=
.38%  qemu-kvm  [kernel.kallsyms]             [k] do=5Fraw=5Fspin=5Ftrylock=
=0A     0.37%  qemu-kvm  [kernel.kallsyms]             [k] register=5Flock=
=5Fclass=0A     0.37%  qemu-kvm  [kernel.kallsyms]             [k] update=
=5Fcfs=5Fshares=0A     0.36%  qemu-kvm  [kernel.kallsyms]             [k] c=
opy=5Fuser=5Fgeneric=5Fstring=0A     0.36%  qemu-kvm  [kernel.kallsyms]    =
         [k] =5F=5Fmight=5Fsleep=0A     0.35%  qemu-kvm  [kvm]             =
            [k] x86=5Femulate=5Finstruction=0A     0.34%  qemu-kvm  libc-2.=
14.so                  [.] =5F=5FGI=5Fioctl=0A     0.34%  qemu-kvm  [kernel=
.kallsyms]             [k] sched=5Fclock=0A     0.32%  qemu-kvm  [kernel.ka=
llsyms]             [k] fget=5Flight=0A     0.32%  qemu-kvm  [kernel.kallsy=
ms]             [k] native=5Fread=5Fmsr=5Fsafe=0A     0.31%  qemu-kvm  [kvm=
=5Fintel]                   [k] vmx=5Fhandle=5Fexit=0A     0.29%  qemu-kvm =
 [kernel.kallsyms]             [k] do=5Fselect=0A     0.29%  qemu-kvm  [kvm=
]                         [k] gfn=5Fto=5Fmemslot=0A     0.28%  qemu-kvm  [k=
vm=5Fintel]                   [k] vmcs=5Fwritel=0A     0.28%  qemu-kvm  [kv=
m]                         [k] kvm=5Fmemslots=0A     0.28%  qemu-kvm  [kvm]=
                         [k] do=5Finsn=5Ffetch=0A     0.27%  qemu-kvm  [ker=
nel.kallsyms]             [k] hash=5F64=0A     0.27%  qemu-kvm  [kvm]      =
                   [k] kvm=5Fcheck=5Frequest=0A     0.27%  qemu-kvm  [kvm] =
                        [k] init=5Femulate=5Fctxt=0A     0.23%  qemu-kvm  [=
kernel.kallsyms]             [k] restore=0A     0.23%  qemu-kvm  [kernel.ka=
llsyms]             [k] paravirt=5Fread=5Ftsc=0A     0.23%  qemu-kvm  [kern=
el.kallsyms]             [k] update=5Fcurr=0A     0.23%  qemu-kvm  [kernel.=
kallsyms]             [k] select=5Ftask=5Frq=5Ffair=0A     0.22%  qemu-kvm =
 [kernel.kallsyms]             [k] do=5Fvfs=5Fioctl=0A     0.21%  qemu-kvm =
 [kvm=5Fintel]                   [k] vmx=5Fsave=5Fhost=5Fstate=0A     0.21%=
  qemu-kvm  [kvm]                         [k] emulator=5Fread=5Fwrite=5Fone=
page=0A     0.21%  qemu-kvm  [kvm]                         [k] =5F=5Flinear=
ize=0A     0.20%  qemu-kvm  [kernel.kallsyms]             [k] fput=0A     0=
.20%  qemu-kvm  [kvm]                         [k] find=5Fhighest=5Fvector=
=0A     0.20%  qemu-kvm  [kernel.kallsyms]             [k] audit=5Fsyscall=
=5Fentry=0A     0.19%  qemu-kvm  [kvm]                         [k] decode=
=5Fmodrm=0A     0.19%  qemu-kvm  [kernel.kallsyms]             [k] schedule=
=0A     0.19%  qemu-kvm  [kernel.kallsyms]             [k] check=5Fbytes=5F=
and=5Freport=0A     0.19%  qemu-kvm  [kvm=5Fintel]                   [k] vm=
x=5Fget=5Fmsr=0A     0.17%  qemu-kvm  [kernel.kallsyms]             [k] aud=
it=5Fsyscall=5Fexit=0A     0.17%  qemu-kvm  libc-2.14.so                  [=
.] =5F=5Fmemmove=5Fssse3=5Fback=0A     0.17%  qemu-kvm  [kvm=5Fintel]      =
             [k] vmx=5Fvcpu=5Fload=0A     0.17%  qemu-kvm  [kernel.kallsyms=
]             [k] arch=5Flocal=5Fsave=5Fflags=0A     0.17%  qemu-kvm  [kern=
el.kallsyms]             [k] =5Fraw=5Fspin=5Flock=5Firqsave=0A     0.16%  q=
emu-kvm  [kernel.kallsyms]             [k] fcheck=5Ffiles=0A     0.16%  qem=
u-kvm  libpthread-2.14.so            [.] pthread=5Fmutex=5Flock=0A     0.16=
%  qemu-kvm  [kernel.kallsyms]             [k] unroll=5Ftree=5Frefs=0A     =
0.15%  qemu-kvm  [kernel.kallsyms]             [k] =5Fraw=5Fspin=5Funlock=
=5Firqrestore=0A     0.15%  qemu-kvm  [kernel.kallsyms]             [k] =5F=
=5Fmutex=5Flock=5Fcommon=0A     0.15%  qemu-kvm  [kernel.kallsyms]         =
    [k] cpuacct=5Fcharge=0A     0.15%  qemu-kvm  [kernel.kallsyms]         =
    [k] do=5Fraw=5Fspin=5Funlock=0A     0.15%  qemu-kvm  [kernel.kallsyms] =
            [k] dequeue=5Ftask=5Ffair=0A     0.15%  qemu-kvm  [kvm]        =
                 [k] kvm=5Fapic=5Faccept=5Fpic=5Fintr=0A     0.14%  qemu-kv=
m  [kernel.kallsyms]             [k] lockdep=5Fsys=5Fexit=5Fthunk=0A     0.=
14%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Flist=5Fdel=5Fentry=
=0A     0.14%  qemu-kvm  [kernel.kallsyms]             [k] trace=5Fhardirqs=
=5Fon=0A     0.14%  qemu-kvm  libpthread-2.14.so            [.] =5F=5Fpthre=
ad=5Fmutex=5Funlock=0A     0.14%  qemu-kvm  [kvm]                         [=
k] kvm=5Fvcpu=5Fioctl=0A     0.14%  qemu-kvm  [kernel.kallsyms]            =
 [k] audit=5Fget=5Fcontext=0A     0.14%  qemu-kvm  [kvm]                   =
      [k] kvm=5Fio=5Fbus=5Fread=0A     0.14%  qemu-kvm  [kvm]              =
           [k] kvm=5Fread=5Fguest=5Fvirt=5Fhelper=0A     0.14%  qemu-kvm  [=
kernel.kallsyms]             [k] native=5Fload=5Ftr=5Fdesc=0A     0.14%  qe=
mu-kvm  [kernel.kallsyms]             [k] ktime=5Fget=0A     0.14%  qemu-kv=
m  [kernel.kallsyms]             [k] update=5Fcfs=5Fload=0A     0.14%  qemu=
-kvm  [kernel.kallsyms]             [k] =5F=5Fsrcu=5Fread=5Flock=0A     0.1=
4%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fperf=5Fevent=5Ftask=
=5Fsched=5Fout=0A     0.13%  qemu-kvm  [kvm]                         [k] kv=
m=5Fregister=5Fread=0A     0.13%  qemu-kvm  [kernel.kallsyms]             [=
k] =5Fraw=5Fspin=5Flock=5Firq=0A     0.13%  qemu-kvm  [kernel.kallsyms]    =
         [k] timerqueue=5Fadd=0A     0.13%  qemu-kvm  [kernel.kallsyms]    =
         [k] atomic64=5Fadd=5Funless.constprop.1=0A     0.13%  qemu-kvm  [k=
vm]                         [k] paging64=5Fgpte=5Faccess=0A     0.13%  qemu=
-kvm  [kernel.kallsyms]             [k] trace=5Fhardirqs=5Foff=5Fthunk=0A  =
   0.13%  qemu-kvm  [kernel.kallsyms]             [k] =5Fcond=5Fresched=0A =
    0.12%  qemu-kvm  [kernel.kallsyms]             [k] tcp=5Fpoll=0A     0.=
12%  qemu-kvm  [kernel.kallsyms]             [k] need=5Fresched=0A     0.12=
%  qemu-kvm  [kvm]                         [k] segmented=5Fread=0A     0.12=
%  qemu-kvm  [kernel.kallsyms]             [k] audit=5Ffree=5Fnames=0A     =
0.12%  qemu-kvm  [kernel.kallsyms]             [k] trace=5Fhardirqs=5Fon=5F=
thunk=0A     0.12%  qemu-kvm  [kvm]                         [k] paging64=5F=
gva=5Fto=5Fgpa=0A     0.12%  qemu-kvm  [kvm]                         [k] ap=
ic=5Fupdate=5Fppr=0A     0.12%  qemu-kvm  [kernel.kallsyms]             [k]=
 generic=5Fexec=5Fsingle=0A     0.12%  qemu-kvm  [kernel.kallsyms]         =
    [k] should=5Fresched=0A     0.11%  qemu-kvm  [kvm=5Fintel]             =
      [k] handle=5Fept=5Fmisconfig=0A     0.11%  qemu-kvm  [kernel.kallsyms=
]             [k] rcu=5Fread=5Flock=0A     0.11%  qemu-kvm  [kvm]          =
               [k] gfn=5Fto=5Fhva=0A     0.11%  qemu-kvm  [kernel.kallsyms]=
             [k] path=5Fput=0A     0.11%  qemu-kvm  [kernel.kallsyms]      =
       [k] account=5Fentity=5Fdequeue=0A     0.11%  qemu-kvm  [kernel.kalls=
yms]             [k] arch=5Flocal=5Firq=5Frestore=0A     0.11%  qemu-kvm  [=
kernel.kallsyms]             [k] =5Fraw=5Fspin=5Flock=0A     0.11%  qemu-kv=
m  [kvm]                         [k] kvm=5Fset=5Fshared=5Fmsr=0A     0.11% =
 qemu-kvm  [kvm]                         [k] emulator=5Fread=5Fwrite=0A    =
 0.11%  qemu-kvm  [kernel.kallsyms]             [k] nf=5Fiterate=0A     0.1=
1%  qemu-kvm  [kvm]                         [k] emulator=5Fcheck=5Fintercep=
t=0A     0.10%  qemu-kvm  [kvm]                         [k] gfn=5Fto=5Fhva=
=5Fmany=0A     0.10%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=5Fs=
egment=5Fcache=5Ftest=5Fset=0A     0.10%  qemu-kvm  [kernel.kallsyms]      =
       [k] calc=5Fdelta=5Fmine=0A     0.10%  qemu-kvm  [kvm=5Fintel]       =
            [k] =5F=5Fvmx=5Fload=5Fhost=5Fstate.part.2=0A     0.10%  qemu-k=
vm  [kernel.kallsyms]             [k] kfree=0A     0.10%  qemu-kvm  [kernel=
.kallsyms]             [k] =5F=5Fhrtimer=5Fstart=5Frange=5Fns=0A     0.10% =
 qemu-kvm  [kvm]                         [k] kvm=5Fset=5Firq=0A     0.10%  =
qemu-kvm  [kernel.kallsyms]             [k] sys=5Fioctl=0A     0.10%  qemu-=
kvm  [kvm]                         [k] kvm=5Fcpu=5Fhas=5Finterrupt=0A     0=
.10%  qemu-kvm  [kernel.kallsyms]             [k] lockdep=5Fsys=5Fexit=0A  =
   0.10%  qemu-kvm  [nf=5Fconntrack]                [k] tcp=5Fpacket=0A    =
 0.10%  qemu-kvm  [kvm]                         [k] kvm=5Farch=5Fvcpu=5Floa=
d=0A     0.10%  qemu-kvm  [kvm]                         [k] decode=5Fregist=
er=5Foperand=0A     0.10%  qemu-kvm  [kernel.kallsyms]             [k] =5F=
=5Flist=5Fadd=0A     0.10%  qemu-kvm  [kvm]                         [k] api=
c=5Fenabled=0A     0.10%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=
=5Fcache=5Freg=0A     0.10%  qemu-kvm  [kvm]                         [k] kv=
m=5Fapic=5Fhas=5Finterrupt=0A     0.10%  qemu-kvm  [kvm]                   =
      [k] trace=5Fkvm=5Fmmu=5Fpagetable=5Fwalk=0A     0.10%  qemu-kvm  [ker=
nel.kallsyms]             [k] slab=5Fpad=5Fcheck.part.7=0A     0.09%  qemu-=
kvm  [kernel.kallsyms]             [k] arch=5Flocal=5Firq=5Fdisable=0A     =
0.09%  qemu-kvm  [kvm]                         [k] write=5Fmmio=0A     0.09=
%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=5Fdecache=5Fcr3=0A    =
 0.09%  qemu-kvm  [kernel.kallsyms]             [k] rb=5Ferase=0A     0.09%=
  qemu-kvm  [ip=5Ftables]                   [k] ipt=5Fdo=5Ftable=0A     0.0=
9%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=5Fget=5Fcpl=0A     0.=
09%  qemu-kvm  [kvm]                         [k] get=5Fcr3=0A     0.09%  qe=
mu-kvm  [kvm]                         [k] walk=5Fshadow=5Fpage=5Fget=5Fmmio=
=5Fspte=0A     0.09%  qemu-kvm  [kernel.kallsyms]             [k] update=5F=
min=5Fvruntime=0A     0.09%  qemu-kvm  [kvm=5Fintel]                   [k] =
vmx=5Fread=5Fguest=5Fseg=5Far=0A     0.09%  qemu-kvm  [kvm]                =
         [k] translate=5Fgpa=0A     0.09%  qemu-kvm  libpthread-2.14.so    =
        [.] =5F=5Flll=5Flock=5Fwait=0A     0.09%  qemu-kvm  [kvm=5Fintel]  =
                 [k] cpu=5Fhas=5Fvirtual=5Fnmis=0A     0.09%  qemu-kvm  [ke=
rnel.kallsyms]             [k] sys=5Ffutex=0A     0.09%  qemu-kvm  [kernel.=
kallsyms]             [k] dput=0A     0.08%  qemu-kvm  [kvm]               =
          [k] kvm=5Farch=5Fvm=5Fioctl=0A     0.08%  qemu-kvm  [kvm]        =
                 [k] srcu=5Fread=5Flock=0A     0.08%  qemu-kvm  [kvm]      =
                   [k] kvm=5Ffetch=5Fguest=5Fvirt=0A     0.08%  qemu-kvm  [=
kernel.kallsyms]             [k] device=5Fnot=5Favailable=0A     0.08%  qem=
u-kvm  [kernel.kallsyms]             [k] put=5Fprev=5Ftask=5Ffair=0A     0.=
08%  qemu-kvm  [kernel.kallsyms]             [k] get=5Ffutex=5Fkey=0A     0=
.08%  qemu-kvm  [kernel.kallsyms].vsyscall=5F0  [.] 0xffffffffff60010c=0A  =
   0.08%  qemu-kvm  [kernel.kallsyms]             [k] task=5Fgroup=0A     0=
.08%  qemu-kvm  [kvm]                         [k] kvm=5Fvm=5Fioctl=0A     0=
.08%  qemu-kvm  [kvm]                         [k] kvm=5Flapic=5Fsync=5Fto=
=5Fvapic=0A     0.08%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=5F=
get=5Finterrupt=5Fshadow=0A     0.08%  qemu-kvm  [kvm]                     =
    [k] kvm=5Fon=5Fuser=5Freturn=0A     0.08%  qemu-kvm  [kernel.kallsyms] =
            [k] delay=5Ftsc=0A     0.08%  qemu-kvm  [kvm]                  =
       [k] paging64=5Fgpte=5Fto=5Fgfn=5Flvl=0A     0.08%  qemu-kvm  [kernel=
.kallsyms]             [k] init=5Fobject=0A     0.08%  qemu-kvm  [kernel.ka=
llsyms]             [k] fire=5Fuser=5Freturn=5Fnotifiers=0A     0.08%  qemu=
-kvm  [kernel.kallsyms]             [k] current=5Fkernel=5Ftime=0A     0.08=
%  qemu-kvm  [kvm]                         [k] check=5Fwrite=5Fuser=5Facces=
s=0A     0.08%  qemu-kvm  [kernel.kallsyms]             [k] clear=5Fti=5Fth=
read=5Fflag.constprop.15=0A     0.08%  qemu-kvm  [vdso]                    =
    [.] 0x7fff8299f9be  =0A     0.08%  qemu-kvm  [kvm]                     =
    [k] kvm=5Fget=5Fmsr=0A     0.08%  qemu-kvm  [kvm=5Fintel]              =
     [k] vmx=5Fread=5Fguest=5Fseg=5Fselector=0A     0.08%  qemu-kvm  [kvm] =
                        [k] kvm=5Fio=5Fbus=5Fwrite=0A     0.08%  qemu-kvm  =
[kvm]                         [k] fetch=5Fregister=5Foperand=0A     0.08%  =
qemu-kvm  [kvm=5Fintel]                   [k] vmx=5Fset=5Frflags=0A     0.0=
8%  qemu-kvm  [kernel.kallsyms]             [k] fsnotify=0A     0.08%  qemu=
-kvm  [kvm]                         [k] update=5Fcr8=5Fintercept=0A     0.0=
8%  qemu-kvm  [kvm]                         [k] coalesced=5Fmmio=5Fwrite=0A=
     0.08%  qemu-kvm  [kernel.kallsyms]             [k] native=5Fload=5Fgdt=
=0A     0.07%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fxapic=5Fwa=
it=5Ficr=5Fidle=0A     0.07%  qemu-kvm  [kernel.kallsyms]             [k] i=
dle=5Fcpu=0A     0.07%  qemu-kvm  [kvm]                         [k] kvm=5Fc=
heck=5Fasync=5Fpf=5Fcompletion=0A     0.07%  qemu-kvm  [kernel.kallsyms]   =
          [k] do=5Ffutex=0A     0.07%  qemu-kvm  [kernel.kallsyms]         =
    [k] source=5Fload=0A     0.07%  qemu-kvm  [kvm]                        =
 [k] emulator=5Fwrite=5Femulated=0A     0.07%  qemu-kvm  [tun]             =
            [k] tun=5Fchr=5Fpoll=0A     0.07%  qemu-kvm  [kernel.kallsyms] =
            [k] recalc=5Fsigpending=5Ftsk=0A     0.07%  qemu-kvm  [kernel.k=
allsyms]             [k] irq=5Fentries=5Fstart=0A     0.07%  qemu-kvm  [kvm=
]                         [k] apic=5Freg=5Fwrite=0A     0.07%  qemu-kvm  [k=
ernel.kallsyms]             [k] set=5Fcurrent=5Fblocked=0A     0.07%  qemu-=
kvm  libpthread-2.14.so            [.] =5F=5Fread=0A     0.07%  qemu-kvm  [=
kernel.kallsyms]             [k] =5Fraw=5Fspin=5Funlock=0A     0.07%  qemu-=
kvm  [kvm]                         [k] handle=5Fmmio=5Fpage=5Ffault=5Fcommo=
n=0A     0.07%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=5Fget=5Fr=
flags=0A     0.07%  qemu-kvm  [kernel.kallsyms]             [k] sigprocmask=
=0A     0.07%  qemu-kvm  [kernel.kallsyms]             [k] sock=5Fpoll=0A  =
   0.07%  qemu-kvm  [kvm]                         [k] kvm=5Fmake=5Frequest=
=0A     0.07%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fsrcu=5Frea=
d=5Funlock=0A     0.06%  qemu-kvm  [kvm]                         [k] kvm=5F=
irq=5Fline=5Fstate=0A     0.06%  qemu-kvm  [kernel.kallsyms]             [k=
] =5F=5Fpollwait=0A     0.06%  qemu-kvm  [kernel.kallsyms]             [k] =
do=5Fnotify=5Fresume=0A     0.06%  qemu-kvm  [kernel.kallsyms]             =
[k] =5F=5Fmutex=5Funlock=5Fslowpath=0A     0.06%  qemu-kvm  [kernel.kallsym=
s]             [k] get=5Fpartial=5Fnode=0A     0.06%  qemu-kvm  [kernel.kal=
lsyms]             [k] futex=5Fwait=0A     0.06%  qemu-kvm  [kernel.kallsym=
s]             [k] futex=5Fwake=0A     0.06%  qemu-kvm  [kernel.kallsyms]  =
           [k] rcu=5Fsched=5Fqs=0A     0.06%  qemu-kvm  librt-2.14.so      =
           [.] =5F=5FGI=5Fclock=5Fgettime=0A     0.06%  qemu-kvm  [kvm]    =
                     [k] apic=5Ffind=5Fhighest=5Firr=0A     0.06%  qemu-kvm=
  [kvm]                         [k] vcpu=5Fmmio=5Fread=0A     0.06%  qemu-k=
vm  [kvm]                         [k] kvm=5Fread=5Fguest=5Fpage=0A     0.06=
%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=5Fheld=0A =
    0.06%  qemu-kvm  [kernel.kallsyms]             [k] =5Fraw=5Fspin=5Funlo=
ck=5Firq=0A     0.06%  qemu-kvm  [kvm]                         [k] em=5Fmov=
=0A     0.06%  qemu-kvm  [kvm]                         [k] trace=5Fkvm=5Fmm=
io=0A     0.06%  qemu-kvm  [kvm]                         [k] kvm=5Fread=5Fg=
uest=0A     0.06%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=5Finte=
rrupt=5Fallowed=0A     0.06%  qemu-kvm  [kvm]                         [k] r=
ead=5Fprepare=0A     0.06%  qemu-kvm  [kernel.kallsyms]             [k] zer=
o=5Ffd=5Fset=0A     0.06%  qemu-kvm  [kernel.kallsyms]             [k] ttwu=
=5Fstat=0A     0.06%  qemu-kvm  [kernel.kallsyms]             [k] user=5Fre=
turn=5Fnotifier=5Funregister=0A     0.05%  qemu-kvm  [kvm]                 =
        [k] kvm=5Fget=5Frflags=0A     0.05%  qemu-kvm  [kvm]               =
          [k] trace=5Fkvm=5Fmmu=5Fpaging=5Felement=0A     0.05%  qemu-kvm  =
[kvm]                         [k] kvm=5Fsched=5Fin=0A     0.05%  qemu-kvm  =
[kernel.kallsyms]             [k] check=5Fvalid=5Fpointer=0A     0.05%  qem=
u-kvm  libc-2.14.so                  [.] =5F=5Flibc=5Fselect=0A     0.05%  =
qemu-kvm  [kernel.kallsyms]             [k] core=5Fsys=5Fselect=0A     0.05=
%  qemu-kvm  [kernel.kallsyms]             [k] clear=5Fbuddies=0A     0.05%=
  qemu-kvm  [kvm]                         [k] segmented=5Fwrite=0A     0.05=
%  qemu-kvm  [kernel.kallsyms]             [k] mntput=0A     0.05%  qemu-kv=
m  [kernel.kallsyms]             [k] tcp=5Fv4=5Frcv=0A     0.05%  qemu-kvm =
 [kernel.kallsyms]             [k] test=5Ftsk=5Fthread=5Fflag=0A     0.05% =
 qemu-kvm  [kernel.kallsyms]             [k] rw=5Fverify=5Farea=0A     0.05=
%  qemu-kvm  [tun]                         [k] tun=5Fget=5Fuser=0A     0.05=
%  qemu-kvm  [kernel.kallsyms]             [k] unix=5Fpoll=0A     0.05%  qe=
mu-kvm  [kernel.kallsyms]             [k] =5F=5Fslab=5Falloc=0A     0.05%  =
qemu-kvm  [kvm]                         [k] srcu=5Fread=5Funlock=0A     0.0=
5%  qemu-kvm  [kernel.kallsyms]             [k] account=5Fentity=5Fenqueue=
=0A     0.05%  qemu-kvm  [kvm]                         [k] kvm=5Flapic=5Fsy=
nc=5Ffrom=5Fvapic=0A     0.05%  qemu-kvm  [kernel.kallsyms]             [k]=
 signalfd=5Fpoll=0A     0.05%  qemu-kvm  [kvm]                         [k] =
kvm=5Flapic=5Fget=5Fcr8=0A     0.05%  qemu-kvm  [kvm]                      =
   [k] vcpu=5Fload=0A     0.05%  qemu-kvm  [kernel.kallsyms]             [k=
] hash=5Ffutex=0A     0.05%  qemu-kvm  [kernel.kallsyms]             [k] do=
=5Fraw=5Fspin=5Flock=0A     0.05%  qemu-kvm  [kernel.kallsyms]             =
[k] native=5Fsmp=5Fsend=5Freschedule=0A     0.05%  qemu-kvm  [kernel.kallsy=
ms]             [k] audit=5Ffree=5Faux=0A     0.05%  qemu-kvm  [kernel.kall=
syms]             [k] find=5Fbusiest=5Fgroup=0A     0.05%  qemu-kvm  [kvm=
=5Fintel]                   [k] paravirt=5Fread=5Fmsr=0A     0.05%  qemu-kv=
m  [kvm]                         [k] emulator=5Fpio=5Fin=5Femulated=0A     =
0.05%  qemu-kvm  [kernel.kallsyms]             [k] poll=5Fselect=5Fcopy=5Fr=
emaining=0A     0.05%  qemu-kvm  [kernel.kallsyms]             [k] lock=5Fh=
rtimer=5Fbase=0A     0.05%  qemu-kvm  [kernel.kallsyms]             [k] sel=
ect=5Festimate=5Faccuracy=0A     0.04%  qemu-kvm  [kernel.kallsyms]        =
     [k] arch=5Flocal=5Firq=5Fsave=0A     0.04%  qemu-kvm  [kvm]           =
              [k] atomic=5Finc=0A     0.04%  qemu-kvm  [bridge]            =
          [k] br=5Fhandle=5Fframe=0A     0.04%  qemu-kvm  [kernel.kallsyms]=
             [k] recalc=5Fsigpending=0A     0.04%  qemu-kvm  libpthread-2.1=
4.so            [.] =5F=5Flll=5Funlock=5Fwake=0A     0.04%  qemu-kvm  [kvm=
=5Fintel]                   [k] vmx=5Fvcpu=5Fput=0A     0.04%  qemu-kvm  [k=
vm]                         [k] kvm=5Fread=5Fcr4=5Fbits=0A     0.04%  qemu-=
kvm  [kernel.kallsyms]             [k] =5F=5Fnetif=5Freceive=5Fskb=0A     0=
.04%  qemu-kvm  [kernel.kallsyms]             [k] paravirt=5Fread=5Ftsc=0A =
    0.04%  qemu-kvm  [kvm]                         [k] apic=5Fmmio=5Fwrite=
=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fmath=5Fsta=
te=5Frestore=0A     0.04%  qemu-kvm  [kvm=5Fintel]                   [k] kv=
m=5Fread=5Fcr0=5Fbits=0A     0.04%  qemu-kvm  [kernel.kallsyms]            =
 [k] task=5Fca=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] si=
gnalfd=5Fread=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] pic=
k=5Fnext=5Ftask=0A     0.04%  qemu-kvm  [kvm]                         [k] k=
vm=5Fset=5Frflags=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k]=
 check=5Fslab=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] deq=
ueue=5Ftask=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] sys=
=5Fread=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] sys=5Fsel=
ect=0A     0.04%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=
=5Firq=5Fsave=0A     0.04%  qemu-kvm  [kvm=5Fintel]                   [k] e=
mulate=5Finstruction=0A     0.04%  qemu-kvm  [kernel.kallsyms]             =
[k] debug=5Fmutex=5Fadd=5Fwaiter=0A     0.04%  qemu-kvm  [kvm]             =
            [k] kvm=5Fapic=5Fpresent=0A     0.04%  qemu-kvm  [kvm]         =
                [k] kvm=5Fvcpu=5Fblock=0A     0.04%  qemu-kvm  [kernel.kall=
syms]             [k] plist=5Fcheck=5Flist=0A     0.04%  qemu-kvm  [kernel.=
kallsyms]             [k] hrtick=5Fupdate=0A     0.04%  qemu-kvm  [kvm]    =
                     [k] arch=5Flocal=5Firq=5Fdisable=0A     0.04%  qemu-kv=
m  [kernel.kallsyms]             [k] auditsys=0A     0.04%  qemu-kvm  [kvm]=
                         [k] vcpu=5Fput=0A     0.04%  qemu-kvm  [kernel.kal=
lsyms]             [k] ip=5Frcv=0A     0.04%  qemu-kvm  [kernel.kallsyms]  =
           [k] arch=5Flocal=5Firq=5Fenable=0A     0.04%  qemu-kvm  [kvm]   =
                      [k] kvm=5Fioapic=5Fset=5Firq=0A     0.04%  qemu-kvm  =
[kernel.kallsyms]             [k] vfs=5Fread=0A     0.04%  qemu-kvm  [tun] =
                        [k] =5F=5Ftun=5Fget=0A     0.04%  qemu-kvm  [kernel=
.kallsyms]             [k] timerqueue=5Fdel=0A     0.04%  qemu-kvm  [kernel=
.kallsyms]             [k] =5F=5Fdo=5Fsoftirq=0A     0.04%  qemu-kvm  [kern=
el.kallsyms]             [k] mutex=5Funlock=0A     0.04%  qemu-kvm  [kernel=
.kallsyms]             [k] on=5Ffreelist=0A     0.04%  qemu-kvm  [xt=5Ftcpu=
dp]                   [k] tcp=5Fmt=0A     0.04%  qemu-kvm  [kernel.kallsyms=
]             [k] mutex=5Flock=5Fnested=0A     0.04%  qemu-kvm  [kernel.kal=
lsyms]             [k] =5F=5Fdequeue=5Fsignal=0A     0.04%  qemu-kvm  [kvm]=
                         [k] kvm=5Fput=5Fguest=5Ffpu=0A     0.04%  qemu-kvm=
  [kernel.kallsyms]             [k] debug=5Fmutex=5Flock=5Fcommon=0A     0.=
04%  qemu-kvm  [kernel.kallsyms]             [k] plist=5Fcheck=5Fhead=0A   =
  0.04%  qemu-kvm  [kvm]                         [k] kvm=5Flapic=5Fenabled=
=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] kmem=5Fcache=5Fa=
lloc=5Fnode=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] hrtim=
er=5Ftry=5Fto=5Fcancel=0A     0.03%  qemu-kvm  [kernel.kallsyms]           =
  [k] =5F=5Frcu=5Fpending=0A     0.03%  qemu-kvm  [kernel.kallsyms]        =
     [k] =5F=5Fwake=5Fup=5Fcommon=0A     0.03%  qemu-kvm  libc-2.14.so     =
             [.] =5F=5Flibc=5Fwritev=0A     0.03%  qemu-kvm  [kernel.kallsy=
ms]             [k] ip=5Froute=5Finput=5Fcommon=0A     0.03%  qemu-kvm  lib=
c-2.14.so                  [.] =5F=5Flibc=5Fdisable=5Fasynccancel=0A     0.=
03%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Finet=5Flookup=5Festa=
blished=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] common=5F=
interrupt=0A     0.03%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=
=5Fset=5Finterrupt=5Fshadow=0A     0.03%  qemu-kvm  [kvm]                  =
       [k] trace=5Fvcpu=5Fmatch=5Fmmio=0A     0.03%  qemu-kvm  [kvm=5Fintel=
]                   [k] init=5Fmodule=0A     0.03%  qemu-kvm  [kvm=5Fintel]=
                   [k] update=5Fcr8=5Fintercept=0A     0.03%  qemu-kvm  [ke=
rnel.kallsyms]             [k] read=5Ftsc=0A     0.03%  qemu-kvm  [kernel.k=
allsyms]             [k] debug=5Fmutex=5Ffree=5Fwaiter=0A     0.03%  qemu-k=
vm  [kernel.kallsyms]             [k] eventfd=5Fpoll=0A     0.03%  qemu-kvm=
  [kernel.kallsyms]             [k] =5Fflat=5Fsend=5FIPI=5Fmask=0A     0.03=
%  qemu-kvm  [kernel.kallsyms]             [k] task=5Fwaking=5Ffair=0A     =
0.03%  qemu-kvm  [bridge]                      [k] br=5Fnf=5Fpre=5Frouting=
=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] user=5Freturn=5F=
notifier=5Fregister=0A     0.03%  qemu-kvm  [kvm]                         [=
k] decode=5Fregister=0A     0.03%  qemu-kvm  [kernel.kallsyms]             =
[k] finish=5Ftask=5Fswitch=0A     0.03%  qemu-kvm  [kernel.kallsyms]       =
      [k] pick=5Fnext=5Ftask=5Fstop=0A     0.03%  qemu-kvm  [kernel.kallsym=
s]             [k] =5F=5Fpercpu=5Fcounter=5Fadd=0A     0.03%  qemu-kvm  [ke=
rnel.kallsyms]             [k] rb=5Finsert=5Fcolor=0A     0.03%  qemu-kvm  =
[kernel.kallsyms]             [k] hrtimer=5Finit=0A     0.03%  qemu-kvm  [k=
vm]                         [k] trace=5Fkvm=5Femulate=5Finsn=0A     0.03%  =
qemu-kvm  [kernel.kallsyms]             [k] get=5Frps=5Fcpu=0A     0.03%  q=
emu-kvm  [kernel.kallsyms]             [k] atomic=5Fdec=5Fand=5Ftest=0A    =
 0.03%  qemu-kvm  [kernel.kallsyms]             [k] set=5Fnormalized=5Ftime=
spec=0A     0.03%  qemu-kvm  [tun]                         [k] tun=5Fdo=5Fr=
ead=0A     0.03%  qemu-kvm  libpthread-2.14.so            [.] =5F=5Ferrno=
=5Flocation=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] rcu=
=5Fread=5Flock=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] sc=
hedule=5Fhrtimeout=5Frange=5Fclock=0A     0.03%  qemu-kvm  [kernel.kallsyms=
]             [k] poll=5Ffreewait=0A     0.03%  qemu-kvm  [kernel.kallsyms]=
             [k] =5Flocal=5Fbh=5Fenable=5Fip=0A     0.03%  qemu-kvm  [kerne=
l.kallsyms]             [k] preempt=5Fnotifier=5Funregister=0A     0.03%  q=
emu-kvm  [kvm]                         [k] rcu=5Fread=5Flock=0A     0.03%  =
qemu-kvm  [kvm]                         [k] shadow=5Fwalk=5Fokay=0A     0.0=
3%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Funlock=0A     =
0.03%  qemu-kvm  [kernel.kallsyms]             [k] int=5Fwith=5Fcheck=0A   =
  0.03%  qemu-kvm  [kvm]                         [k] apic=5Freg=5Fread=0A  =
   0.03%  qemu-kvm  [kernel.kallsyms]             [k] check=5Fobject=0A    =
 0.03%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fremove=5Fhrtimer=
=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] next=5Fsignal=0A=
     0.03%  qemu-kvm  [nf=5Fconntrack]                [k] nf=5Fconntrack=5F=
in=0A     0.03%  qemu-kvm  [kvm]                         [k] check=5Fperm=
=5Fin=0A     0.03%  qemu-kvm  [kvm]                         [k] kvm=5Farch=
=5Fvcpu=5Frunnable=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k=
] flat=5Fsend=5FIPI=5Fmask=0A     0.03%  qemu-kvm  [kernel.kallsyms]       =
      [k] radix=5Ftree=5Flookup=5Felement=0A     0.03%  qemu-kvm  [kvm]    =
                     [k] copy=5Ffrom=5Fuser=0A     0.03%  qemu-kvm  [kvm]  =
                       [k] kvm=5Firq=5Fdelivery=5Fto=5Fapic=0A     0.03%  q=
emu-kvm  [kernel.kallsyms]             [k] list=5Fdel=0A     0.03%  qemu-kv=
m  [kernel.kallsyms]             [k] ktime=5Fget=5Fts=0A     0.03%  qemu-kv=
m  [kernel.kallsyms]             [k] =5F=5Falloc=5Fskb=0A     0.03%  qemu-k=
vm  [kernel.kallsyms]             [k] copy=5Ffrom=5Fuser=0A     0.03%  qemu=
-kvm  [kernel.kallsyms]             [k] x86=5Fpmu=5Fdisable=0A     0.03%  q=
emu-kvm  [kernel.kallsyms]             [k] timekeeping=5Fget=5Fns=0A     0.=
03%  qemu-kvm  [kernel.kallsyms]             [k] task=5Fof=0A     0.03%  qe=
mu-kvm  [kernel.kallsyms]             [k] lock=5Fcontended=0A     0.03%  qe=
mu-kvm  [kernel.kallsyms]             [k] atomic=5Finc=0A     0.03%  qemu-k=
vm  [bridge]                      [k] br=5Fnf=5Fpre=5Frouting=5Ffinish=0A  =
   0.03%  qemu-kvm  [kernel.kallsyms]             [k] fsnotify=5Faccess=0A =
    0.03%  qemu-kvm  [kvm]                         [k] arch=5Flocal=5Firq=
=5Fenable=0A     0.03%  qemu-kvm  [kvm]                         [k] kvm=5Fi=
oapic=5Fupdate=5Feoi=0A     0.03%  qemu-kvm  [kvm]                         =
[k] kvm=5Fget=5Fcr8=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [=
k] sysret=5Faudit=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k]=
 enqueue=5Fhrtimer=0A     0.03%  qemu-kvm  [kvm]                         [k=
] write=5Fregister=5Foperand=0A     0.03%  qemu-kvm  [kernel.kallsyms]     =
        [k] arch=5Flocal=5Firq=5Frestore=0A     0.03%  qemu-kvm  [kvm=5Fint=
el]                   [k] paravirt=5Fwrite=5Fmsr=0A     0.03%  qemu-kvm  [k=
ernel.kallsyms]             [k] =5F=5Flocal=5Fbh=5Fdisable=0A     0.03%  qe=
mu-kvm  [kernel.kallsyms]             [k] hrtimer=5Finterrupt=0A     0.03% =
 qemu-kvm  [kernel.kallsyms]             [k] =5F=5Flock=5Ftimer=0A     0.03=
%  qemu-kvm  [kvm]                         [k] kvm=5Fread=5Fcr0=5Fbits=0A  =
   0.03%  qemu-kvm  libpthread-2.14.so            [.] =5F=5Fpthread=5Fenabl=
e=5Fasynccancel=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] h=
rtimer=5Fcancel=0A     0.03%  qemu-kvm  [kernel.kallsyms]             [k] =
=5F=5Fkmalloc=5Fnode=5Ftrack=5Fcaller=0A     0.03%  qemu-kvm  [kernel.kalls=
yms]             [k] arch=5Flocal=5Fsave=5Fflags=0A     0.03%  qemu-kvm  li=
bpthread-2.14.so            [.] =5F=5Flibc=5Fsigaction=0A     0.03%  qemu-k=
vm  [kernel.kallsyms]             [k] =5F=5Ffsnotify=5Fparent=0A     0.03% =
 qemu-kvm  [kvm]                         [k] walk=5Fshadow=5Fpage=5Flockles=
s=5Fbegin=0A     0.03%  qemu-kvm  [kvm=5Fintel]                   [k] handl=
e=5Fapic=5Faccess=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k]=
 =5F=5Fphys=5Faddr=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k=
] handle=5Fedge=5Firq=0A     0.02%  qemu-kvm  [bridge]                     =
 [k] NF=5FHOOK=5FTHRESH=0A     0.02%  qemu-kvm  [kernel.kallsyms]          =
   [k] update=5Frq=5Fclock=0A     0.02%  qemu-kvm  [kernel.kallsyms]       =
      [k] arch=5Flocal=5Firq=5Frestore=0A     0.02%  qemu-kvm  [kernel.kall=
syms]             [k] add=5Fwait=5Fqueue=0A     0.02%  qemu-kvm  [iptable=
=5Fnat]                 [k] nf=5Fnat=5Ffn=0A     0.02%  qemu-kvm  [kernel.k=
allsyms]             [k] select=5Ftask=5Frq=0A     0.02%  qemu-kvm  libc-2.=
14.so                  [.] =5Fint=5Ffree=0A     0.02%  qemu-kvm  [kernel.ka=
llsyms]             [k] math=5Fstate=5Frestore=0A     0.02%  qemu-kvm  [nf=
=5Fconntrack]                [k] tcp=5Ferror=0A     0.02%  qemu-kvm  [kerne=
l.kallsyms]             [k] signal=5Fpending=0A     0.02%  qemu-kvm  [bridg=
e]                      [k] br=5Fhandle=5Fframe=5Ffinish=0A     0.02%  qemu=
-kvm  [kernel.kallsyms]             [k] vfs=5Fwritev=0A     0.02%  qemu-kvm=
  [kernel.kallsyms]             [k] do=5FIRQ=0A     0.02%  qemu-kvm  [kvm] =
                        [k] kvm=5Flapic=5Ffind=5Fhighest=5Firr=0A     0.02%=
  qemu-kvm  [tun]                         [k] atomic=5Fdec=5Fand=5Ftest=0A =
    0.02%  qemu-kvm  [tun]                         [k] tun=5Fsock=5Fwrite=
=5Fspace=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] debug=5F=
mutex=5Funlock=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] sc=
heduler=5Ftick=0A     0.02%  qemu-kvm  librt-2.14.so                 [.] =
=5F=5Ftimer=5Fgettime=5Fnew=0A     0.02%  qemu-kvm  [kvm]                  =
       [k] apic=5Fhas=5Fpending=5Ftimer=0A     0.02%  qemu-kvm  [kernel.kal=
lsyms]             [k] common=5Ftimer=5Fget=0A     0.02%  qemu-kvm  libc-2.=
14.so                  [.] =5F=5Fgettimeofday=5Finternal=0A     0.02%  qemu=
-kvm  [kernel.kallsyms]             [k] do=5Fsoftirq=0A     0.02%  qemu-kvm=
  [kernel.kallsyms]             [k] mutex=5Fremove=5Fwaiter=0A     0.02%  q=
emu-kvm  [kvm]                         [k] emulator=5Fread=5Femulated=0A   =
  0.02%  qemu-kvm  [kernel.kallsyms]             [k] call=5Fsoftirq=0A     =
0.02%  qemu-kvm  [kernel.kallsyms]             [k] process=5Fbacklog=0A    =
 0.02%  qemu-kvm  [kernel.kallsyms]             [k] ip=5Flocal=5Fdeliver=5F=
finish=0A     0.02%  qemu-kvm  [kvm]                         [k] =5F=5Fapic=
=5Faccept=5Firq=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] =
=5F=5Fmod=5Ftimer=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k]=
 futex=5Fwait=5Fqueue=5Fme=0A     0.02%  qemu-kvm  [kernel.kallsyms]       =
      [k] perf=5Fpmu=5Fdisable=0A     0.02%  qemu-kvm  [kernel.kallsyms]   =
          [k] account=5Fgroup=5Fexec=5Fruntime=0A     0.02%  qemu-kvm  [ker=
nel.kallsyms]             [k] remove=5Fwait=5Fqueue=0A     0.02%  qemu-kvm =
 [kvm]                         [k] pic=5Fset=5Firq1=0A     0.02%  qemu-kvm =
 [kernel.kallsyms]             [k] run=5Ftimer=5Fsoftirq=0A     0.02%  qemu=
-kvm  [kvm]                         [k] ioapic=5Fmmio=5Fread=0A     0.02%  =
qemu-kvm  [kvm]                         [k] kvm=5Farch=5Fvcpu=5Fput=0A     =
0.02%  qemu-kvm  [kernel.kallsyms]             [k] set=5Ffd=5Fset=0A     0.=
02%  qemu-kvm  [kernel.kallsyms]             [k] preempt=5Fnotifier=5Fregis=
ter=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] load=5Fbalanc=
e=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] net=5Frx=5Facti=
on=0A     0.02%  qemu-kvm  [bridge]                      [k] compare=5Fethe=
r=5Faddr=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] ip=5Frcv=
=5Ffinish=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] ktime=
=5Fadd=5Fsafe=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] =5F=
=5Fset=5Ftask=5Fblocked=0A     0.02%  qemu-kvm  [kernel.kallsyms]          =
   [k] sock=5Fpoll=5Fwait=0A     0.02%  qemu-kvm  [kernel.kallsyms]        =
     [k] prepare=5Fto=5Fwait=0A     0.02%  qemu-kvm  [kernel.kallsyms]     =
        [k] futex=5Fwait=5Fsetup=0A     0.02%  qemu-kvm  [iptable=5Fmangle]=
              [k] iptable=5Fmangle=5Fhook=0A     0.02%  qemu-kvm  [kernel.k=
allsyms]             [k] sock=5Falloc=5Fsend=5Fpskb=0A     0.02%  qemu-kvm =
 [kernel.kallsyms]             [k] pick=5Fnext=5Ftask=5Frt=0A     0.02%  qe=
mu-kvm  libpthread-2.14.so            [.] sigaction=0A     0.02%  qemu-kvm =
 [kernel.kallsyms]             [k] =5Fcopy=5Ffrom=5Fuser=0A     0.02%  qemu=
-kvm  [kvm]                         [k] kvm=5Fnotify=5Facked=5Firq=0A     0=
.02%  qemu-kvm  [kvm]                         [k] apic=5Fset=5Fvector=0A   =
  0.02%  qemu-kvm  [kernel.kallsyms]             [k] handle=5Firq=5Fevent=
=5Fpercpu=0A     0.02%  qemu-kvm  [kvm]                         [k] start=
=5Fapic=5Ftimer=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] s=
ys=5Ftimer=5Fgettime=0A     0.02%  qemu-kvm  [kernel.kallsyms]             =
[k] =5F=5Fclear=5Fuser=0A     0.02%  qemu-kvm  [nf=5Fconntrack]            =
    [k] =5F=5F=5F=5Fnf=5Fconntrack=5Ffind=0A     0.02%  qemu-kvm  [kvm]    =
                     [k] is=5Fshadow=5Fpresent=5Fpte=0A     0.02%  qemu-kvm=
  [kernel.kallsyms]             [k] idr=5Ffind=0A     0.02%  qemu-kvm  [ker=
nel.kallsyms]             [k] arch=5Flocal=5Firq=5Fdisable=0A     0.02%  qe=
mu-kvm  [kernel.kallsyms]             [k] tg=5Fload=5Fdown=0A     0.02%  qe=
mu-kvm  libc-2.14.so                  [.] =5F=5Flibc=5Fenable=5Fasynccancel=
=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] trace=5Fsoftirqs=
=5Foff=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] update=5Fs=
hares=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] native=5Fap=
ic=5Fmem=5Fwrite=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] =
task=5Ftick=5Ffair=0A     0.02%  qemu-kvm  [kvm]                         [k=
] write=5Fexit=5Fmmio=0A     0.02%  qemu-kvm  [kvm]                        =
 [k] trace=5Fkvm=5Fapic=0A     0.02%  qemu-kvm  [kernel.kallsyms]          =
   [k] rcu=5Fnote=5Fcontext=5Fswitch=0A     0.02%  qemu-kvm  [kvm]         =
                [k] kvm=5Fpic=5Fset=5Firq=0A     0.02%  qemu-kvm  [kernel.k=
allsyms]             [k] common=5Ftimer=5Fset=0A     0.02%  qemu-kvm  [brid=
ge]                      [k] br=5Fport=5Fget=5Frcu=0A     0.02%  qemu-kvm  =
[kvm]                         [k] ioapic=5Fmmio=5Fwrite=0A     0.02%  qemu-=
kvm  [kvm=5Fintel]                   [k] vmx=5Finject=5Firq=0A     0.02%  q=
emu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=5Fheld=0A     =
0.02%  qemu-kvm  [kvm]                         [k] pic=5Fupdate=5Firq=0A   =
  0.02%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=0A  =
   0.02%  qemu-kvm  [kernel.kallsyms]             [k] cpumask=5Fnext=5Fand=
=0A     0.02%  qemu-kvm  [kvm]                         [k] kvm=5Fapic=5Fmat=
ch=5Flogical=5Faddr=0A     0.02%  qemu-kvm  [kvm]                         [=
k] shadow=5Fwalk=5Finit=0A     0.02%  qemu-kvm  [kernel.kallsyms]          =
   [k] do=5Fsigaction=0A     0.02%  qemu-kvm  [nf=5Fnat]                   =
   [k] nf=5Fnat=5Fpacket=0A     0.02%  qemu-kvm  [kernel.kallsyms]         =
    [k] update=5Fcpu=5Fload=0A     0.02%  qemu-kvm  [kernel.kallsyms]      =
       [k] deactivate=5Ftask=0A     0.02%  qemu-kvm  [kernel.kallsyms]     =
        [k] pick=5Fnext=5Ftask=5Ffair=0A     0.02%  qemu-kvm  [kernel.kalls=
yms]             [k] poll=5Fschedule=5Ftimeout=0A     0.02%  qemu-kvm  [ker=
nel.kallsyms]             [k] clockevents=5Fprogram=5Fevent=0A     0.02%  q=
emu-kvm  [kvm]                         [k] pic=5Funlock=0A     0.02%  qemu-=
kvm  [kvm]                         [k] kvm=5Farch=5Finterrupt=5Fallowed=0A =
    0.02%  qemu-kvm  [kernel.kallsyms]             [k] deactivate=5Fslab=0A=
     0.02%  qemu-kvm  [kernel.kallsyms]             [k] kmem=5Fcache=5Fallo=
c=5Ftrace=0A     0.02%  qemu-kvm  [nf=5Fconntrack]                [k] =5F=
=5Fnf=5Fct=5Fl3proto=5Ffind=0A     0.02%  qemu-kvm  [kernel.kallsyms]      =
       [k] nf=5Fhook=5Fslow=0A     0.02%  qemu-kvm  [kernel.kallsyms]      =
       [k] slab=5Fpre=5Falloc=5Fhook=0A     0.02%  qemu-kvm  [kernel.kallsy=
ms]             [k] sys=5Ftimer=5Fsettime=0A     0.02%  qemu-kvm  [kernel.k=
allsyms]             [k] hrtick=5Fstart=5Ffair=0A     0.02%  qemu-kvm  [ker=
nel.kallsyms]             [k] intel=5Fpmu=5Fdisable=5Fall=0A     0.02%  qem=
u-kvm  [kernel.kallsyms]             [k] cpu=5Favg=5Fload=5Fper=5Ftask=0A  =
   0.02%  qemu-kvm  [kvm]                         [k] pit=5Fioport=5Fread=
=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=5Fi=
rq=5Frestore=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] dequ=
eue=5Fsignal=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [k] acco=
unt=5Fsystem=5Ftime=0A     0.02%  qemu-kvm  [kvm]                         [=
k] ioapic=5Fservice=0A     0.02%  qemu-kvm  [kernel.kallsyms]             [=
k] enqueue=5Fto=5Fbacklog=0A     0.02%  qemu-kvm  [kernel.kallsyms]        =
     [k] fsnotify=5Fmodify=0A     0.01%  qemu-kvm  libc-2.14.so            =
      [.] =5Fint=5Fmalloc=0A     0.01%  qemu-kvm  [kernel.kallsyms]        =
     [k] sys=5Fwritev=0A     0.01%  qemu-kvm  [kernel.kallsyms]            =
 [k] plist=5Fadd=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] =
finish=5Fwait=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] tes=
t=5Ftsk=5Fthread=5Fflag=0A     0.01%  qemu-kvm  libpthread-2.14.so         =
   [.] =5F=5Fpthread=5Fdisable=5Fasynccancel=0A     0.01%  qemu-kvm  [kerne=
l.kallsyms]             [k] sock=5Fupdate=5Fclassid=0A     0.01%  qemu-kvm =
 [tun]                         [k] netif=5Fwake=5Fqueue=0A     0.01%  qemu-=
kvm  [kernel.kallsyms]             [k] eth=5Ftype=5Ftrans=0A     0.01%  qem=
u-kvm  [kernel.kallsyms]             [k] skb=5Fdst=0A     0.01%  qemu-kvm  =
[kernel.kallsyms]             [k] skb=5Fdequeue=0A     0.01%  qemu-kvm  [ke=
rnel.kallsyms]             [k] skb=5Fpull=5Frcsum=0A     0.01%  qemu-kvm  [=
kernel.kallsyms]             [k] do=5Freadv=5Fwritev=0A     0.01%  qemu-kvm=
  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=0A     0.01%  qemu-kv=
m  [tun]                         [k] tun=5Fchr=5Faio=5Fwrite=0A     0.01%  =
qemu-kvm  [kvm=5Fintel]                   [k] is=5Fpaging=0A     0.01%  qem=
u-kvm  [tun]                         [k] tun=5Fchr=5Faio=5Fread=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] trace=5Fsoftirqs=5Fon=0A    =
 0.01%  qemu-kvm  [nf=5Fconntrack]                [k] =5F=5Fnf=5Fct=5Fl4pro=
to=5Ffind=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] dst=5Fm=
etric=0A     0.01%  qemu-kvm  librt-2.14.so                 [.] =5F=5Ftimer=
=5Fsettime=5Fnew=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] =
perf=5Fevent=5Ftask=5Ftick=0A     0.01%  qemu-kvm  qemu-kvm                =
      [.] ioctl@plt=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [=
k] put=5Ftask=5Fstruct=0A     0.01%  qemu-kvm  [kvm]                       =
  [k] apic=5Fmmio=5Fread=0A     0.01%  qemu-kvm  [kernel.kallsyms]         =
    [k] timespec=5Fadd=5Fsafe=0A     0.01%  qemu-kvm  [kvm]                =
         [k] kvm=5Frip=5Fread=0A     0.01%  qemu-kvm  [kernel.kallsyms]    =
         [k] rb=5Fnext=0A     0.01%  qemu-kvm  libz.so.1.2.5               =
  [.] 0x29e0          =0A     0.01%  qemu-kvm  [kernel.kallsyms]           =
  [k] signal=5Fpending=5Fstate=0A     0.01%  qemu-kvm  libpthread-2.14.so  =
          [.] =5FL=5Flock=5F758=0A     0.01%  qemu-kvm  [bridge]           =
           [k] br=5Fparse=5Fip=5Foptions=0A     0.01%  qemu-kvm  [kernel.ka=
llsyms]             [k] alloc=5Fdebug=5Fprocessing=0A     0.01%  qemu-kvm  =
[kernel.kallsyms]             [k] find=5Fnext=5Fbit=0A     0.01%  qemu-kvm =
 [kernel.kallsyms]             [k] netif=5Frx=0A     0.01%  qemu-kvm  [kern=
el.kallsyms]             [k] add=5Fpartial=0A     0.01%  qemu-kvm  [kernel.=
kallsyms]             [k] skb=5Fput=0A     0.01%  qemu-kvm  [kernel.kallsym=
s]             [k] cpuacct=5Fupdate=5Fstats=0A     0.01%  qemu-kvm  [kvm]  =
                       [k] emulator=5Fbad=5Fiopl=0A     0.01%  qemu-kvm  [b=
ridge]                      [k] =5F=5Fbr=5Ffdb=5Fget=0A     0.01%  qemu-kvm=
  [kernel.kallsyms]             [k] irq=5Fexit=0A     0.01%  qemu-kvm  [ker=
nel.kallsyms]             [k] perf=5Fevent=5Ftask=5Fsched=5Fout=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] skb=5Fcopy=5Fdatagram=5Ffrom=
=5Fiovec=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] set=5Ftr=
ack=0A     0.01%  qemu-kvm  [kvm=5Fintel]                   [k] skip=5Femul=
ated=5Finstruction=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k=
] rcu=5Fread=5Flock=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [=
k] skb=5Frelease=5Fhead=5Fstate=0A     0.01%  qemu-kvm  [kernel.kallsyms]  =
           [k] irq=5Fenter=0A     0.01%  qemu-kvm  [kernel.kallsyms]       =
      [k] =5F=5Fslab=5Ffree=0A     0.01%  qemu-kvm  [kernel.kallsyms]      =
       [k] get=5Ffutex=5Fkey=5Frefs=0A     0.01%  qemu-kvm  [kvm]          =
               [k] speaker=5Fioport=5Fread=0A     0.01%  qemu-kvm  [iptable=
=5Ffilter]              [k] iptable=5Ffilter=5Fhook=0A     0.01%  qemu-kvm =
 [bridge]                      [k] br=5Ffdb=5Fupdate=0A     0.01%  qemu-kvm=
  [bridge]                      [k] nf=5Fbridge=5Fencap=5Fheader=5Flen=0A  =
   0.01%  qemu-kvm  libc-2.14.so                  [.] =5F=5Fmalloc=0A     0=
.01%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=5Firq=5Frest=
ore=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] irq=5Fcomplet=
e=5Fmove=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] hrtimer=
=5Fstart=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] int=5Fre=
store=5Frest=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] rcu=
=5Fbh=5Fqs=0A     0.01%  qemu-kvm  [kvm]                         [k] kvm=5F=
make=5Frequest=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] rc=
u=5Fexit=5Fnohz=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] g=
et=5Fparent=5Fip=0A     0.01%  qemu-kvm  [nf=5Fconntrack=5Fipv4]           =
[k] ipv4=5Fconfirm=0A     0.01%  qemu-kvm  [iptable=5Fnat]                 =
[k] nf=5Fnat=5Fin=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k]=
 x86=5Fpmu=5Fenable=0A     0.01%  qemu-kvm  [nf=5Fconntrack]               =
 [k] segment=5Fseq=5Fplus=5Flen=0A     0.01%  qemu-kvm  [kernel.kallsyms]  =
           [k] hpet=5Fmsi=5Fnext=5Fevent=0A     0.01%  qemu-kvm  [kernel.ka=
llsyms]             [k] rcu=5Fenter=5Fnohz=0A     0.01%  qemu-kvm  [kernel.=
kallsyms]             [k] profile=5Ftick=0A     0.01%  qemu-kvm  [kernel.ka=
llsyms]             [k] arch=5Flocal=5Firq=5Fdisable=0A     0.01%  qemu-kvm=
  [kvm]                         [k] kvm=5Fvcpu=5Fkick=0A     0.01%  qemu-kv=
m  [kernel.kallsyms]             [k] handle=5Firq=5Fevent=0A     0.01%  qem=
u-kvm  [kernel.kallsyms]             [k] atomic=5Fdec=5Fand=5Ftest=0A     0=
.01%  qemu-kvm  [bridge]                      [k] pskb=5Fmay=5Fpull=0A     =
0.01%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fcheck=5Fcallbacks=
=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] pick=5Fnext=5Fta=
sk=5Fidle=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] paravir=
t=5Fwrite=5Fmsr=0A     0.01%  qemu-kvm  [kvm=5Fintel]                   [k]=
 handle=5Fio=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] inet=
=5Fcsk=5Freset=5Fxmit=5Ftimer.constprop.14=0A     0.01%  qemu-kvm  [nf=5Fco=
nntrack]                [k] hash=5Fconntrack=5Fraw=0A     0.01%  qemu-kvm  =
libc-2.14.so                  [.] malloc=5Fconsolidate.part.3=0A     0.01% =
 qemu-kvm  [kernel.kallsyms]             [k] atomic=5Fdec=5Fand=5Ftest=0A  =
   0.01%  qemu-kvm  [kernel.kallsyms]             [k] ip=5Flocal=5Fdeliver=
=0A     0.01%  qemu-kvm  [bridge]                      [k] br=5Fport=5Fget=
=5Frcu=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] update=5Fp=
rocess=5Ftimes=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] in=
t=5Fsignal=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] int=5F=
check=5Fsyscall=5Fexit=5Fwork=0A     0.01%  qemu-kvm  [kernel.kallsyms]    =
         [k] do=5Fsync=5Freadv=5Fwritev=0A     0.01%  qemu-kvm  [kernel.kal=
lsyms]             [k] sys=5Frt=5Fsigaction=0A     0.01%  qemu-kvm  [kernel=
.kallsyms]             [k] atomic=5Fadd=0A     0.01%  qemu-kvm  [kernel.kal=
lsyms]             [k] tick=5Fprogram=5Fevent=0A     0.01%  qemu-kvm  [kern=
el.kallsyms]             [k] arch=5Flocal=5Firq=5Frestore=0A     0.01%  qem=
u-kvm  [kernel.kallsyms]             [k] =5F=5Frun=5Fhrtimer=0A     0.01%  =
qemu-kvm  [kvm=5Fintel]                   [k] handle=5Fhalt=0A     0.01%  q=
emu-kvm  [kernel.kallsyms]             [k] csum=5Fpartial=0A     0.01%  qem=
u-kvm  [nf=5Fconntrack]                [k] atomic=5Fadd=5Funless.constprop.=
5=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] netif=5Freceive=
=5Fskb=0A     0.01%  qemu-kvm  libpthread-2.14.so            [.] =5FL=5Funl=
ock=5F686=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] radix=
=5Ftree=5Flookup=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] =
eventfd=5Fwrite=0A     0.01%  qemu-kvm  [kvm=5Fintel]                   [k]=
 =5F=5Finvept.constprop.48=0A     0.01%  qemu-kvm  [kernel.kallsyms]       =
      [k] tick=5Fsched=5Ftimer=0A     0.01%  qemu-kvm  [kernel.kallsyms]   =
          [k] rcu=5Fread=5Flock=5Fheld=0A     0.01%  qemu-kvm  [kernel.kall=
syms]             [k] run=5Flocal=5Ftimers=0A     0.01%  qemu-kvm  [nf=5Fco=
nntrack]                [k] =5F=5Fnf=5Fconntrack=5Ffind=5Fget=0A     0.01% =
 qemu-kvm  [kernel.kallsyms]             [k] sk=5Fsleep=0A     0.01%  qemu-=
kvm  [nf=5Fconntrack=5Fipv4]           [k] ipv4=5Fget=5Fl4proto=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] do=5Fdevice=5Fnot=5Favailabl=
e=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] schedule=5Fhrti=
meout=5Frange=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] skb=
=5Fdst=5Fset=5Fnoref=0A     0.01%  qemu-kvm  [kernel.kallsyms]             =
[k] rcu=5Fread=5Flock=0A     0.01%  qemu-kvm  [kernel.kallsyms]            =
 [k] do=5Fsync=5Fread=0A     0.01%  qemu-kvm  [kernel.kallsyms]            =
 [k] vfs=5Fwrite=0A     0.01%  qemu-kvm  [kvm=5Fintel]                   [k=
] kvm=5Fregister=5Fread=0A     0.01%  qemu-kvm  [kernel.kallsyms]          =
   [k] tick=5Fdev=5Fprogram=5Fevent=0A     0.01%  qemu-kvm  [kernel.kallsym=
s]             [k] =5Fcopy=5Fto=5Fuser=0A     0.01%  qemu-kvm  [kernel.kall=
syms]             [k] =5F=5Fbit=5Fspin=5Funlock.constprop.21=0A     0.01%  =
qemu-kvm  [kernel.kallsyms]             [k] drop=5Ffutex=5Fkey=5Frefs=0A   =
  0.01%  qemu-kvm  [kernel.kallsyms]             [k] get=5Ffd=5Fset=0A     =
0.01%  qemu-kvm  [kernel.kallsyms]             [k] set=5Fnext=5Fbuddy=0A   =
  0.01%  qemu-kvm  [kernel.kallsyms]             [k] hpet=5Finterrupt=5Fhan=
dler=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] lock=5Fpoint=
=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] NF=5FHOOK.constp=
rop.2=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Frb=5F=
rotate=5Fleft=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] =5F=
=5Frb=5Frotate=5Fright=0A     0.01%  qemu-kvm  [kvm]                       =
  [k] kvm=5Fset=5Fpic=5Firq=0A     0.01%  qemu-kvm  [kernel.kallsyms]      =
       [k] fput=5Flight=0A     0.01%  qemu-kvm  [bridge]                   =
   [k] br=5Fmac=5Fhash=0A     0.01%  qemu-kvm  [kernel.kallsyms]           =
  [k] nf=5Fip=5Fchecksum=0A     0.01%  qemu-kvm  [kernel.kallsyms]         =
    [k] debug=5Fcheck=5Fno=5Flocks=5Ffreed=0A     0.01%  qemu-kvm  [kernel.=
kallsyms]             [k] arch=5Flocal=5Fsave=5Fflags=0A     0.01%  qemu-kv=
m  [kernel.kallsyms]             [k] rcu=5Fread=5Funlock=0A     0.01%  qemu=
-kvm  [kernel.kallsyms]             [k] atomic=5Fdec=5Fand=5Ftest=0A     0.=
01%  qemu-kvm  [kernel.kallsyms]             [k] save=5Fargs=0A     0.01%  =
qemu-kvm  [kvm=5Fintel]                   [k] =5F=5Finvvpid.constprop.47=0A=
     0.01%  qemu-kvm  qemu-kvm                      [.] pthread=5Fmutex=5Fu=
nlock@plt=0A     0.01%  qemu-kvm  [nf=5Fnat]                      [k] nf=5F=
nat=5Fget=5Foffset=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k=
] hrtimer=5Frun=5Fqueues=0A     0.01%  qemu-kvm  [kernel.kallsyms]         =
    [k] =5Fraw=5Fspin=5Flock=5Fnested=0A     0.01%  qemu-kvm  [kernel.kalls=
yms]             [k] rcu=5Fread=5Flock=5Fheld=0A     0.01%  qemu-kvm  [kern=
el.kallsyms]             [k] skb=5Fpush=0A     0.01%  qemu-kvm  [bridge]   =
                   [k] nf=5Fbridge=5Fput=0A     0.01%  qemu-kvm  [kernel.ka=
llsyms]             [k] debug=5Fdeactivate=0A     0.01%  qemu-kvm  [kernel.=
kallsyms]             [k] rcu=5Fread=5Flock=0A     0.01%  qemu-kvm  [kernel=
.kallsyms]             [k] memcpy=5Ffromiovecend=0A     0.01%  qemu-kvm  [k=
ernel.kallsyms]             [k] default=5Fwake=5Ffunction=0A     0.01%  qem=
u-kvm  [nf=5Fconntrack=5Fipv4]           [k] ipv4=5Fconntrack=5Fin=0A     0=
.01%  qemu-kvm  [kernel.kallsyms]             [k] srcu=5Fread=5Flock=5Fheld=
.constprop.2=0A     0.01%  qemu-kvm  libpthread-2.14.so            [.] =5F=
=5Flibc=5Fwrite=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] e=
ventfd=5Fctx=5Fread=0A     0.01%  qemu-kvm  [kvm]                         [=
k] kvm=5Fapic=5Fmatch=5Fdest=0A     0.01%  qemu-kvm  [kernel.kallsyms]     =
        [k] slab=5Ffree=5Fhook=0A     0.01%  qemu-kvm  [kernel.kallsyms]   =
          [k] skb=5Fcopy=5Fdatagram=5Fconst=5Fiovec=0A     0.01%  qemu-kvm =
 [bridge]                      [k] setup=5Fpre=5Frouting=0A     0.01%  qemu=
-kvm  [kernel.kallsyms]             [k] hrtimer=5Fforward=0A     0.01%  qem=
u-kvm  [bridge]                      [k] rcu=5Fread=5Flock=5Fheld=0A     0.=
01%  qemu-kvm  [kernel.kallsyms]             [k] sock=5Fflag=0A     0.01%  =
qemu-kvm  [kvm]                         [k] rcu=5Fread=5Funlock=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] exit=5Fidle=0A     0.01%  qe=
mu-kvm  [kernel.kallsyms]             [k] rcu=5Firq=5Fenter=0A     0.01%  q=
emu-kvm  [kernel.kallsyms]             [k] do=5Ftimer=0A     0.01%  qemu-kv=
m  [kernel.kallsyms]             [k] lockdep=5Ftrace=5Falloc=0A     0.01%  =
qemu-kvm  [kernel.kallsyms]             [k] skb=5Frelease=5Fdata=0A     0.0=
1%  qemu-kvm  [kernel.kallsyms]             [k] ctx=5Fsched=5Fout=0A     0.=
01%  qemu-kvm  [kernel.kallsyms]             [k] hrtimer=5Fstart=5Frange=5F=
ns=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] detach=5Ftimer=
=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] printk=5Ftick=0A=
     0.01%  qemu-kvm  [bridge]                      [k] ip=5Fsabotage=5Fin=
=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] account=5Fproces=
s=5Ftick=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Fl=
ocal=5Firq=5Fsave=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k]=
 rcu=5Fread=5Funlock=0A     0.01%  qemu-kvm  [kernel.kallsyms]             =
[k] mod=5Ftimer=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] s=
k=5Ffilter=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] clocki=
d=5Fto=5Fkclock=0A     0.01%  qemu-kvm  [nf=5Fconntrack]                [k]=
 =5F=5Fnf=5Fct=5Frefresh=5Facct=0A     0.01%  qemu-kvm  [kernel.kallsyms]  =
           [k] compound=5Forder=0A     0.01%  qemu-kvm  [kernel.kallsyms]  =
           [k] error=5Fexit=0A     0.01%  qemu-kvm  [kernel.kallsyms]      =
       [k] =5F=5Fenqueue=5Fentity=0A     0.01%  qemu-kvm  [bridge]         =
             [k] has=5Fexpired=0A     0.01%  qemu-kvm  [kvm]               =
          [k] picdev=5Fread=0A     0.01%  qemu-kvm  [kernel.kallsyms]      =
       [k] rcu=5Fread=5Flock=5Fheld=0A     0.01%  qemu-kvm  [kernel.kallsym=
s]             [k] rcu=5Fread=5Flock=5Fheld=0A     0.01%  qemu-kvm  [kernel=
.kallsyms]             [k] error=5Fentry=0A     0.01%  qemu-kvm  [kernel.ka=
llsyms]             [k] =5F=5Fdelay=0A     0.01%  qemu-kvm  [kernel.kallsym=
s]             [k] inet=5Fehashfn=0A     0.01%  qemu-kvm  [kernel.kallsyms]=
             [k] acct=5Fupdate=5Fintegrals=0A     0.01%  qemu-kvm  [kernel.=
kallsyms]             [k] free=5Fdebug=5Fprocessing=0A     0.01%  qemu-kvm =
 [nf=5Fconntrack]                [k] skb=5Fheader=5Fpointer=0A     0.01%  q=
emu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=0A     0.01%  =
qemu-kvm  [kvm]                         [k] kvm=5Fcpu=5Fhas=5Fpending=5Ftim=
er=0A     0.01%  qemu-kvm  [kvm]                         [k] kernel=5Fpio=
=0A     0.01%  qemu-kvm  [kvm]                         [k] kvm=5Femulate=5F=
halt=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] ack=5Fapic=
=5Fedge=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] irq=5Fmov=
e=5Firq=0A     0.01%  qemu-kvm  [nf=5Fnat]                      [k] nfct=5F=
nat=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=
=5Firq=5Fenable=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] i=
rq=5Fto=5Fdesc=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] at=
omic=5Fadd=5Funless.constprop.2=0A     0.01%  qemu-kvm  [kernel.kallsyms]  =
           [k] irq=5Fwork=5Frun=0A     0.01%  qemu-kvm  [kernel.kallsyms]  =
           [k] pagefault=5Fenable=0A     0.01%  qemu-kvm  [kernel.kallsyms]=
             [k] rcu=5Fread=5Flock=5Fheld=0A     0.01%  qemu-kvm  [xt=5Ftcp=
udp]                   [k] skb=5Fheader=5Fpointer=0A     0.01%  qemu-kvm  q=
emu-kvm                      [.] write@plt=0A     0.01%  qemu-kvm  [kvm]   =
                      [k] kvm=5Fmake=5Frequest=0A     0.01%  qemu-kvm  [nf=
=5Fconntrack]                [k] nf=5Fct=5Fget=5Ftuple=0A     0.01%  qemu-k=
vm  [kernel.kallsyms]             [k] sock=5Fwfree=0A     0.01%  qemu-kvm  =
[kernel.kallsyms]             [k] sk=5Freset=5Ftimer=0A     0.01%  qemu-kvm=
  qemu-kvm                      [.] gettimeofday@plt=0A     0.01%  qemu-kvm=
  [bridge]                      [k] vlan=5Fproto=0A     0.01%  qemu-kvm  [k=
vm]                         [k] kvm=5Fget=5Fapic=5Fbase=0A     0.01%  qemu-=
kvm  [ip=5Ftables]                   [k] xt=5Fwrite=5Frecseq=5Fbegin=0A    =
 0.01%  qemu-kvm  [kernel.kallsyms]             [k] sys=5Fwrite=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] pskb=5Fmay=5Fpull=0A     0.0=
1%  qemu-kvm  qemu-kvm                      [.] read@plt=0A     0.01%  qemu=
-kvm  [kernel.kallsyms]             [k] intel=5Fpmu=5Fnhm=5Fenable=5Fall=0A=
     0.01%  qemu-kvm  [kernel.kallsyms]             [k] raise=5Fsoftirq=0A =
    0.01%  qemu-kvm  [nf=5Fconntrack=5Fipv4]           [k] ipv4=5Fpkt=5Fto=
=5Ftuple=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] tracesys=
=0A     0.01%  qemu-kvm  qemu-kvm                      [.] memcpy@plt=0A   =
  0.01%  qemu-kvm  [nf=5Fconntrack]                [k] nf=5Fct=5Ftuple=5Feq=
ual=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] lock=5Ftimer=
=5Fbase=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] get=5Ffut=
ex=5Fvalue=5Flocked=0A     0.01%  qemu-kvm  [kvm]                         [=
k] emulator=5Fget=5Fcpl=0A     0.01%  qemu-kvm  [kernel.kallsyms]          =
   [k] prefetchw=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] =
arch=5Flocal=5Fsave=5Fflags=0A     0.01%  qemu-kvm  [kernel.kallsyms]      =
       [k] autoremove=5Fwake=5Ffunction=0A     0.01%  qemu-kvm  [kernel.kal=
lsyms]             [k] ns=5Fto=5Ftimespec=0A     0.01%  qemu-kvm  [kernel.k=
allsyms]             [k] arch=5Flocal=5Firq=5Frestore=0A     0.01%  qemu-kv=
m  [kernel.kallsyms]             [k] =5F=5Fsk=5Fdst=5Fget=0A     0.01%  qem=
u-kvm  [nf=5Fdefrag=5Fipv4]              [k] nf=5Fdefrag=5Ffini=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Funlock=0A     0=
.01%  qemu-kvm  [kernel.kallsyms]             [k] note=5Finterrupt=0A     0=
.01%  qemu-kvm  [kernel.kallsyms]             [k] send=5Fsigqueue=0A     0.=
01%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fperf=5Fevent=5Ftask=
=5Fsched=5Fin=0A     0.01%  qemu-kvm  [kernel.kallsyms]             [k] rcu=
=5Fread=5Funlock=0A     0.01%  qemu-kvm  [nf=5Fdefrag=5Fipv4]              =
[k] ipv4=5Fconntrack=5Fdefrag=0A     0.01%  qemu-kvm  [kernel.kallsyms]    =
         [k] rcu=5Fread=5Flock=5Fheld=0A     0.01%  qemu-kvm  [kernel.kalls=
yms]             [k] rt=5Fhash=0A     0.01%  qemu-kvm  [nf=5Fconntrack]    =
            [k] tcp=5Fpkt=5Fto=5Ftuple=0A     0.01%  qemu-kvm  [kernel.kall=
syms]             [k] rw=5Fcopy=5Fcheck=5Fuvector=0A     0.01%  qemu-kvm  [=
kernel.kallsyms]             [k] set=5Ftask=5Frq=0A     0.01%  qemu-kvm  [k=
ernel.kallsyms]             [k] wake=5Fup=5Fstate=0A     0.01%  qemu-kvm  [=
kernel.kallsyms]             [k] =5F=5Fraise=5Fsoftirq=5Firqoff=0A     0.01=
%  qemu-kvm  [kernel.kallsyms]             [k] set=5Ftask=5Fcpu=0A     0.00=
%  qemu-kvm  [kernel.kallsyms]             [k] skb=5Fdst=0A     0.00%  qemu=
-kvm  [kernel.kallsyms]             [k] bit=5Fspin=5Flock.constprop.22=0A  =
   0.00%  qemu-kvm  [kernel.kallsyms]             [k] raw=5Flocal=5Fdeliver=
=0A     0.00%  qemu-kvm  [kvm]                         [k] rcu=5Fread=5Floc=
k=5Fheld=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fkf=
ree=5Fskb=0A     0.00%  qemu-kvm  libpthread-2.14.so            [.] 0xdf69 =
         =0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] task=5F=
nice=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fraise=
=5Fsoftirq=5Firqoff.constprop.37=0A     0.00%  qemu-kvm  [kernel.kallsyms] =
            [k] insert=5Fwork=0A     0.00%  qemu-kvm  [kernel.kallsyms]    =
         [k] hrtimer=5Fforce=5Freprogram=0A     0.00%  qemu-kvm  [kernel.ka=
llsyms]             [k] jiffies=5Fto=5Ftimeval=0A     0.00%  qemu-kvm  [kvm=
]                         [k] walk=5Fshadow=5Fpage=5Flockless=5Fend=0A     =
0.00%  qemu-kvm  [kernel.kallsyms]             [k] trace=5Fkmalloc=5Fnode=
=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Flocal=5Fbh=
=5Fenable=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] poll=5F=
initwait=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =5Fraw=
=5Fspin=5Flock=5Fbh=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [=
k] debug=5Factivate=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [=
k] net=5Frps=5Faction=5Fand=5Firq=5Fenable=0A     0.00%  qemu-kvm  [kernel.=
kallsyms]             [k] arch=5Flocal=5Fsave=5Fflags=0A     0.00%  qemu-kv=
m  [kernel.kallsyms]             [k] get=5Fslab=0A     0.00%  qemu-kvm  [ke=
rnel.kallsyms]             [k] rcu=5Fread=5Flock=5Fheld=0A     0.00%  qemu-=
kvm  [kernel.kallsyms]             [k] enqueue=5Ftask=5Ffair=0A     0.00%  =
qemu-kvm  [kernel.kallsyms]             [k] local=5Fbh=5Fdisable=0A     0.0=
0%  qemu-kvm  [kernel.kallsyms]             [k] wants=5Fsignal=0A     0.00%=
  qemu-kvm  [kernel.kallsyms]             [k] handle=5Firq=0A     0.00%  qe=
mu-kvm  [kernel.kallsyms]             [k] =5F=5Fsigqueue=5Ffree=0A     0.00=
%  qemu-kvm  [kernel.kallsyms]             [k] arch=5Flocal=5Firq=5Frestore=
=0A     0.00%  qemu-kvm  [kvm]                         [k] kvm=5Fget=5Fapic=
=5Finterrupt=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] enqu=
eue=5Ftask=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] call=
=5Ffunction=5Fsingle=5Finterrupt=0A     0.00%  qemu-kvm  [kvm]             =
            [k] =5F=5Fshadow=5Fwalk=5Fnext=0A     0.00%  qemu-kvm  [bridge]=
                      [k] rcu=5Fread=5Flock=5Fheld=0A     0.00%  qemu-kvm  =
[kernel.kallsyms]             [k] sched=5Fclock=5Ftick=0A     0.00%  qemu-k=
vm  [kvm=5Fintel]                   [k] segment=5Fbase=0A     0.00%  qemu-k=
vm  [kernel.kallsyms]             [k] run=5Fposix=5Fcpu=5Ftimers=0A     0.0=
0%  qemu-kvm  [kvm]                         [k] lapic=5Fis=5Fperiodic=0A   =
  0.00%  qemu-kvm  [kernel.kallsyms]             [k] memcpy=5Ftoiovecend=0A=
     0.00%  qemu-kvm  [kernel.kallsyms]             [k] poll=5Fselect=5Fset=
=5Ftimeout=0A     0.00%  qemu-kvm  [kvm=5Fintel]                   [k] vmx=
=5Fflush=5Ftlb=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =
=5F=5Fwake=5Fup=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] p=
ollwake=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] ttwu=5Fdo=
=5Fwakeup=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] monoton=
ic=5Fto=5Fbootbased=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [=
k] =5F=5Fskb=5Fchecksum=5Fcomplete=5Fhead=0A     0.00%  qemu-kvm  [kernel.k=
allsyms]             [k] tick=5Fdo=5Fupdate=5Fjiffies64=0A     0.00%  qemu-=
kvm  [bridge]                      [k] bridge=5Fparent=5Frtable=0A     0.00=
%  qemu-kvm  [kernel.kallsyms]             [k] next=5Fthread=0A     0.00%  =
qemu-kvm  [kernel.kallsyms]             [k] internal=5Fadd=5Ftimer=0A     0=
.00%  qemu-kvm  [kernel.kallsyms]             [k] atomic=5Fcmpxchg=0A     0=
.00%  qemu-kvm  [bridge]                      [k] nf=5Fbridge=5Falloc=0A   =
  0.00%  qemu-kvm  [kvm]                         [k] read=5Fexit=5Fmmio=0A =
    0.00%  qemu-kvm  qemu-kvm                      [.] clock=5Fgettime@plt=
=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Floc=
k=5Fheld=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] match=5F=
futex=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] native=5Fse=
nd=5Fcall=5Ffunc=5Fsingle=5Fipi=0A     0.00%  qemu-kvm  [bridge]           =
           [k] br=5Fnf=5Flocal=5Fin=0A     0.00%  qemu-kvm  [kernel.kallsym=
s]             [k] apic=5Fwrite=0A     0.00%  qemu-kvm  [kvm=5Fintel]      =
             [k] vmx=5Fclear=5Fhlt=0A     0.00%  qemu-kvm  [bridge]        =
              [k] nf=5Fbridge=5Fupdate=5Fprotocol=0A     0.00%  qemu-kvm  [=
kernel.kallsyms]             [k] =5F=5Fqueue=5Fwork=0A     0.00%  qemu-kvm =
 [kernel.kallsyms]             [k] find=5Ffirst=5Fbit=0A     0.00%  qemu-kv=
m  [kernel.kallsyms]             [k] activate=5Ftask=0A     0.00%  qemu-kvm=
  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=0A     0.00%  qemu-kv=
m  [kernel.kallsyms]             [k] plist=5Fdel=0A     0.00%  qemu-kvm  [k=
ernel.kallsyms]             [k] =5Fraw=5Fspin=5Funlock=5Fbh=0A     0.00%  q=
emu-kvm  [kernel.kallsyms]             [k] target=5Fload=0A     0.00%  qemu=
-kvm  [kernel.kallsyms]             [k] copy=5Ffrom=5Fuser=0A     0.00%  qe=
mu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=0A     0.00%  q=
emu-kvm  [kernel.kallsyms]             [k] =5F=5Flock=5Ftask=5Fsighand=0A  =
   0.00%  qemu-kvm  [kvm]                         [k] =5F=5Fkvm=5Fmigrate=
=5Fpit=5Ftimer=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] ac=
k=5FAPIC=5Firq=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] ar=
ch=5Flocal=5Fsave=5Fflags=0A     0.00%  qemu-kvm  [kvm]                    =
     [k] kvm=5Ftimer=5Ffn=0A     0.00%  qemu-kvm  libc-2.14.so             =
     [.] =5F=5Fmemset=5Fsse2=0A     0.00%  qemu-kvm  [kvm]                 =
        [k] pic=5Fget=5Firq=0A     0.00%  qemu-kvm  [kvm=5Fintel]          =
         [k] handle=5Fexception=0A     0.00%  qemu-kvm  [kernel.kallsyms]  =
           [k] pagefault=5Fdisable=0A     0.00%  qemu-kvm  [kernel.kallsyms=
]             [k] smp=5Fcall=5Ffunction=5Fsingle=5Finterrupt=0A     0.00%  =
qemu-kvm  [kernel.kallsyms]             [k] hrtimer=5Fstart=5Fexpires=0A   =
  0.00%  qemu-kvm  [kernel.kallsyms]             [k] check=5Fpreempt=5Fcurr=
=0A     0.00%  qemu-kvm  [kvm]                         [k] =5F=5Fkvm=5Fmigr=
ate=5Fapic=5Ftimer=0A     0.00%  qemu-kvm  qemu-kvm                      [.=
] select@plt=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] nati=
ve=5Fflush=5Ftlb=5Fglobal=0A     0.00%  qemu-kvm  [kernel.kallsyms]        =
     [k] atomic=5Fsub=0A     0.00%  qemu-kvm  [kernel.kallsyms]            =
 [k] resched=5Ftask=0A     0.00%  qemu-kvm  [bridge]                      [=
k] NF=5FHOOK.constprop.1=0A     0.00%  qemu-kvm  [kernel.kallsyms]         =
    [k] csd=5Flock=0A     0.00%  qemu-kvm  qemu-kvm                      [.=
] timer=5Fgettime@plt=0A     0.00%  qemu-kvm  [kernel.kallsyms]            =
 [k] =5F=5Fenqueue=5Frt=5Fentity=0A     0.00%  qemu-kvm  [kvm]             =
            [k] kvm=5Fcpu=5Fget=5Finterrupt=0A     0.00%  qemu-kvm  [kernel=
.kallsyms]             [k] smp=5Fcall=5Ffunction=5Fsingle=0A     0.00%  qem=
u-kvm  [kernel.kallsyms]             [k] invoke=5Frcu=5Fcpu=5Fkthread=0A   =
  0.00%  qemu-kvm  [kernel.kallsyms]             [k] check=5Ftsc=5Funstable=
=0A     0.00%  qemu-kvm  [kvm]                         [k] apic=5Fclear=5Fv=
ector=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] netif=5Frx=
=5Fni=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] reschedule=
=5Finterrupt=0A     0.00%  qemu-kvm  libc-2.14.so                  [.] call=
oc=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] eventfd=5Fread=
=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] intel=5Fpmu=5Fen=
able=5Fall=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] virt=
=5Fto=5Fhead=5Fpage=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [=
k] check=5Fpreempt=5Fwakeup=0A     0.00%  qemu-kvm  [kernel.kallsyms]      =
       [k] prepare=5Fsignal=0A     0.00%  qemu-kvm  [kernel.kallsyms]      =
       [k] local=5Fbh=5Fenable=5Fip=0A     0.00%  qemu-kvm  [kernel.kallsym=
s]             [k] wake=5Ffutex=0A     0.00%  qemu-kvm  [kernel.kallsyms]  =
           [k] sock=5Frecvmsg=0A     0.00%  qemu-kvm  [kvm]                =
         [k] kvm=5Fset=5Fioapic=5Firq=0A     0.00%  qemu-kvm  [kernel.kalls=
yms]             [k] perf=5Fpmu=5Fenable=0A     0.00%  qemu-kvm  [bridge]  =
                    [k] nf=5Fbridge=5Fpull=5Fencap=5Fheader=5Frcsum=0A     =
0.00%  qemu-kvm  [kernel.kallsyms]             [k] trace=5Fworkqueue=5Facti=
vate=5Fwork=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] enque=
ue=5Ftask=5Frt=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] pe=
rf=5Fevent=5Fcontext=5Fsched=5Fin=0A     0.00%  qemu-kvm  [kernel.kallsyms]=
             [k] wakeup=5Fpreempt=5Fentity=0A     0.00%  qemu-kvm  [kernel.=
kallsyms]             [k] rcu=5Firq=5Fexit=0A     0.00%  qemu-kvm  [kernel.=
kallsyms]             [k] kthread=5Fdata=0A     0.00%  qemu-kvm  [kernel.ka=
llsyms]             [k] test=5Ftsk=5Fneed=5Fresched=0A     0.00%  qemu-kvm =
 [kernel.kallsyms]             [k] =5F=5Fput=5Fuser=5F8=0A     0.00%  qemu-=
kvm  [kvm]                         [k] kvm=5Fapic=5Fcompare=5Fprio=0A     0=
.00%  qemu-kvm  [kernel.kallsyms]             [k] kfree=5Fskb=0A     0.00% =
 qemu-kvm  [kernel.kallsyms]             [k] generic=5Fsmp=5Fcall=5Ffunctio=
n=5Fsingle=5Finterrupt=0A     0.00%  qemu-kvm  [kernel.kallsyms]           =
  [k] timespec=5Fadd=0A     0.00%  qemu-kvm  [kernel.kallsyms]             =
[k] arch=5Flocal=5Firq=5Fenable=0A     0.00%  qemu-kvm  [kernel.kallsyms]  =
           [k] wake=5Fup=5Fworker=0A     0.00%  qemu-kvm  [kernel.kallsyms]=
             [k] =5F=5Funqueue=5Ffutex=0A     0.00%  qemu-kvm  [kvm=5Fintel=
]                   [k] vmx=5Fcancel=5Finjection=0A     0.00%  qemu-kvm  [k=
ernel.kallsyms]             [k] rcu=5Fread=5Flock=5Fheld=0A     0.00%  qemu=
-kvm  [kernel.kallsyms]             [k] skb=5Fchecksum=0A     0.00%  qemu-k=
vm  [kernel.kallsyms]             [k] =5F=5Fskb=5Fdequeue=0A     0.00%  qem=
u-kvm  libc-2.14.so                  [.] =5F=5Fstrcmp=5Fsse42=0A     0.00% =
 qemu-kvm  [kernel.kallsyms]             [k] mix=5Fpool=5Fbytes=5Fextract=
=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] place=5Fentity=
=0A     0.00%  qemu-kvm  libc-2.14.so                  [.] =5F=5Fcfree=0A  =
   0.00%  qemu-kvm  [kvm]                         [k] trace=5Fkvm=5Fpio=0A =
    0.00%  qemu-kvm  [kernel.kallsyms]             [k] rcu=5Fread=5Flock=5F=
held=0A     0.00%  qemu-kvm  [kvm=5Fintel]                   [k] loaded=5Fv=
mcs=5Finit=0A     0.00%  qemu-kvm  [kvm]                         [k] arch=
=5Flocal=5Fsave=5Fflags=0A     0.00%  qemu-kvm  libc-2.14.so               =
   [.] =5Fitoa=5Fword=0A     0.00%  qemu-kvm  [kernel.kallsyms]            =
 [k] posix=5Ftimer=5Ffn=0A     0.00%  qemu-kvm  [kvm=5Fintel]              =
     [k] vpid=5Fsync=5Fcontext=0A     0.00%  qemu-kvm  [ip=5Ftables]       =
            [k] xt=5Fwrite=5Frecseq=5Fend=0A     0.00%  qemu-kvm  [kernel.k=
allsyms]             [k] local=5Fbh=5Fenable=0A     0.00%  qemu-kvm  [kerne=
l.kallsyms]             [k] group=5Ffirst=5Fcpu=0A     0.00%  qemu-kvm  [ke=
rnel.kallsyms]             [k] format=5Fdecode=0A     0.00%  qemu-kvm  [ker=
nel.kallsyms]             [k] raise=5Fsoftirq=5Firqoff=0A     0.00%  qemu-k=
vm  [kernel.kallsyms]             [k] hrtimer=5Frun=5Fpending=0A     0.00% =
 qemu-kvm  [kernel.kallsyms]             [k] =5F=5Finet=5Flookup.constprop.=
13=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] hid=5Freport=
=5Fraw=5Fevent=0A     0.00%  qemu-kvm  [kvm=5Fintel]                   [k] =
handle=5Finterrupt=5Fwindow=0A     0.00%  qemu-kvm  [kernel.kallsyms]      =
       [k] arch=5Flocal=5Fsave=5Fflags=0A     0.00%  qemu-kvm  [kernel.kall=
syms]             [k] rcu=5Fread=5Funlock=0A     0.00%  qemu-kvm  [kernel.k=
allsyms]             [k] =5F=5Fcond=5Fresched=0A     0.00%  qemu-kvm  [kern=
el.kallsyms]             [k] set=5Fnext=5Fentity=0A     0.00%  qemu-kvm  [k=
ernel.kallsyms]             [k] arch=5Flocal=5Firq=5Fdisable=0A     0.00%  =
qemu-kvm  [kvm=5Fintel]                   [k] =5F=5Floaded=5Fvmcs=5Fclear=
=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fwake=5Fup=
=5Fsync=5Fkey=0A     0.00%  qemu-kvm  [kvm=5Fintel]                   [k] h=
andle=5Fexternal=5Finterrupt=0A     0.00%  qemu-kvm  [nf=5Fconntrack]      =
          [k] rcu=5Fread=5Flock=0A     0.00%  qemu-kvm  [kernel.kallsyms]  =
           [k] getnstimeofday=0A     0.00%  qemu-kvm  [kvm]                =
         [k] kvm=5Fapic=5Fset=5Firq=0A     0.00%  qemu-kvm  qemu-kvm       =
               [.] pthread=5Fmutex=5Flock@plt=0A     0.00%  qemu-kvm  [kern=
el.kallsyms]             [k] copy=5Ffrom=5Fuser=0A     0.00%  qemu-kvm  [ke=
rnel.kallsyms]             [k] in=5Flock=5Ffunctions=0A     0.00%  qemu-kvm=
  [kernel.kallsyms]             [k] delayed=5Fwork=5Ftimer=5Ffn=0A     0.00=
%  qemu-kvm  [kernel.kallsyms]             [k] sock=5Fput=0A     0.00%  qem=
u-kvm  [kernel.kallsyms]             [k] =5F=5Ftask=5Frq=5Flock=0A     0.00=
%  qemu-kvm  [tun]                         [k] tun=5Fput=0A     0.00%  qemu=
-kvm  [kernel.kallsyms]             [k] set=5Ftsk=5Fneed=5Fresched=0A     0=
.00%  qemu-kvm  qemu-kvm                      [.] timer=5Fsettime@plt=0A   =
  0.00%  qemu-kvm  libc-2.14.so                  [.] =5F=5FGI=5Fvfprintf=0A=
     0.00%  qemu-kvm  [kvm]                         [k] mark=5Fpage=5Fdirty=
=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] =5F=5Fskb=5Fchec=
ksum=5Fcomplete=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] s=
tring=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] complete=5F=
signal=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] cpumask=5F=
copy=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] rt=5Ftask=5F=
of=0A     0.00%  qemu-kvm  qemu-kvm                      [.] =5F=5Ferrno=5F=
location@plt=0A     0.00%  qemu-kvm  [kernel.kallsyms]             [k] upda=
te=5Fstats=5Fwait=5Fend=0A     0.00%  qemu-kvm  [kernel.kallsyms]          =
   [k] rcu=5Fread=5Funlock=0A     0.00%  qemu-kvm  [kernel.kallsyms]       =
      [k] cgroup=5Flock=5Fis=5Fheld=0A     0.00%  qemu-kvm  [kernel.kallsym=
s]             [k] verify=5Fiovec=0A     0.00%  qemu-kvm  libpthread-2.14.s=
o            [.] =5F=5Frecvmsg=0A     0.00%  qemu-kvm  [kernel.kallsyms]   =
          [k] unix=5Fstream=5Frecvmsg=0A     0.00%  qemu-kvm  [kernel.kalls=
yms]             [k] cpumask=5Fnext=0A     0.00%  qemu-kvm  [kernel.kallsym=
s]             [k] scm=5Fdestroy=0A     0.00%  qemu-kvm  [kernel.kallsyms] =
            [k] rcu=5Fread=5Funlock=0A     0.00%  qemu-kvm  [kernel.kallsym=
s]             [k] rt=5Fse=5Fprio=0A     0.00%  qemu-kvm  [kernel.kallsyms]=
             [k] atomic=5Finc=0A     0.00%  qemu-kvm  [kernel.kallsyms]    =
         [k] rcu=5Fread=5Flock=5Fheld=0A     0.00%  qemu-kvm  [kernel.kalls=
yms]             [k] get=5Fwork=5Fcwq=0A     0.00%  qemu-kvm  [kernel.kalls=
yms]             [k] hrtimer=5Fstart=5Fexpires=0A     0.00%  qemu-kvm  [ker=
nel.kallsyms]             [k] msecs=5Fto=5Fjiffies=0A=0A=0A#=0A# (For a hig=
her level overview, try: perf report --sort comm,dso)=0A#=0A=

--------------010404000102090100050103--
