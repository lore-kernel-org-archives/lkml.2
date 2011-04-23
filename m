Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1DWQ3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:15 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35022 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1DWQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:28:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 00/18] RAS daemon: Easter Eggs Edition
Date: Sat, 23 Apr 2011 18:28:02 +0200
Message-Id: <1303576100-425-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Ok, here's yet another version of the RAS daemon patchset. This one
changes all the event handling to how it is done in test__basic_mmap(),
as acme suggested. Patchset is against tip/perf/core from today.

With this I can inject an mce using the python script below (yeah, work
in progress in itself):

$ mcegen.py -i sw

	[ this will inject a random MCE using the mce_amd_inj.ko module ]

and in /var/log/ras.log I get:

MCE on cpu 0, status: 0xf200210000000853, addr: 0x0000000000000000
MCE on cpu 0, status: 0x9800400000000015, addr: 0x0000000000000000
MCE on cpu 0, status: 0xfc00200000050e0f, addr: 0x0000000000000000
MCE on cpu 0, status: 0x98004100001c010b, addr: 0x0000000000000000
MCE on cpu 0, status: 0xbc00200000000843, addr: 0x0000000000000000
MCE on cpu 0, status: 0xda00410000080e0f, addr: 0x0000000000000000

Yep, it is still raw info but you can do almost anything with that info
in userspace.

Next on the TODO list is changing the tracepoint to convey the decoded
info too which should be a fairly simple task to do.

So we've got the basic design hammered out methinks, the persistent
event is off by default for now and since rebasing this pile is always a
great PITA for me due to other developments in tools/perf, I'd like it
very much if I could offload it in -tip soon.

Also, last time there was a concern raised in the LWN article on the RAS
daemon that the library split is kinda questionable. Well, the argument
I use was the specific topic each piece of the code belongs to:

lib/lk/ is generic stuff which could very well be used by other tools in
the growing tools/ directory (hurray!).

lib/trace/ is the trace event parsing stuff from Steven

lib/perf/ is all the perf-related functionality that other tools might
use too when they need perf events, like this very same RAS daemon does.

Also, the expectation is that trace and perf should merge some day (for
arbitrary meaning of "some day" :)).

Also, I've exported only the stuff I need for the daemon and not
everything, like acme suggested at the time.

Anyway, I'm open to all suggestions and comments, as always.

Thanks.

--
#!/usr/bin/python

import os
import sys
import struct
import inspect
import subprocess
from random import *
from optparse import OptionParser

eecs = ['ECC/Resv', 'CRC', 'Sync', 'Mst Abort', 'Tgt Abort',                         #0-4
        'GART', 'RMW', 'WDT', 'ECC', 'DEV', 'Link Data',                             #5-10
        'Protocol', 'NB Array', 'DRAM Parity', 'Link Retry',                         #11-14
        'GART/DEV Table Walk', 'Resv', 'Resv', 'Resv', 'Resv', 'Resv',               #15-20
        'Resv', 'Resv', 'Resv', 'Resv', 'Resv', 'Resv',                              #21-26
        'Resv', 'L3 Cache Data', 'L3 Cache Tag', 'L3 Cache LRU', 'Probe Filter']     #27-31

r4s = ['GEN', 'RD', 'WR', 'DRD', 'DWR', 'IRD', 'PRF', 'EV', 'SNP']
lls = ['RESV', 'L1', 'L2', 'LG' ]
iis = ['MEM', 'RESV', 'IO', 'GEN' ]
tts = ['INSN', 'DATA', 'GEN', 'RESV' ]
pps = ['SRC', 'RES', 'OBS', 'GEN' ]

fus = {'DC': 0, 'IC': 1, 'BU': 2, 'CU': 2, 'LS': 3, 'NB': 4, 'FR': 5, 'EX': 5, 'FP': 6}
error_types = ['TLB', 'MEM', 'BUS']

families = ['k8', 'f10h', 'f11h', 'f12h', 'f14h', 'f15h']

# MSRs
MSR_K7_HWCR = 0xc0010015

MSR_IA32_MC0_CTL    = 0x00000400
MSR_IA32_MC0_STATUS = 0x00000401
MSR_IA32_MC0_ADDR   = 0x00000402
MSR_IA32_MC0_MISC   = 0x00000403

def MSR_IA32_MCx_CTL(x):        return MSR_IA32_MC0_CTL + 4*x
def MSR_IA32_MCx_STATUS(x):     return MSR_IA32_MC0_STATUS + 4*x
def MSR_IA32_MCx_ADDR(x):       return MSR_IA32_MC0_ADDR + 4*x
def MSR_IA32_MCx_MISC(x):       return MSR_IA32_MC0_MISC + 4*x


def __func__(lvl=1):
    return inspect.stack()[lvl][3]

def err(s):
    sys.stderr.write(("%s: Error %s\n" % (__func__(2), s)))

def dbg(s):
    if opts.dbg:
        sys.stderr.write(("%s: %s\n" % (__func__(2), s)))

def bit(b):
    if b < 0 or b > 63:
        return 0
    return 1L << b

class MCE(object):
    """ Class representing a Machine Check Exception signature
    """

    mci_status  = 0
    syndrome    = 0
    fu          = 'DC'  # DC MCE by default
    err_type    = 'BUS'

    def __init__(self, val=0, fu='DC', err_type='BUS'):
        self.err_type = err_type
        self.fu = fu

        if val:
            self.mci_status = val
        else:
            self.gen_mce()


    def eec(self, mce=None):
        if mce:
            return (mce >> 16) & 0x1f

        return (self.mci_status >> 16) & 0x1f

    def __is_ecc(self, mce=None):
        return self.eec(mce) == 0x8

    def _sanitize_error_type(self, mce):
        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce &= 0xffffffffffff001f
        # MEM
        elif ec & bit(8):
            mce &= 0xffffffffffff01ffL
            # RRRR is max 8
            if mce & bit(7):
                mce &= ~(0x7 << 4)
        # BUS
        elif ec & bit(11):
            mce &= 0xffffffffffff0fffL
            # RRRR is max 8
            if mce & bit(7):
                mce &= ~(0x7 << 4)

        else:
            # fallback to a BUS error (those are most common: DRAM ECC)
            mce &= 0xffffffffffff0fffL
            mce |= bit(11)

        return mce

    def __prep_TLB(self, mce):
        # cleanup fields first
        mce &= 0xffffffffffe00010L

        # ErrorCodeExt[19:16] selects between TLB error types
        # BD introduces a locked TLB miss with EEC=0x2
        eec = randint(0,2)

        return mce | eec << 16

    def __prep_MEM(self, mce):
        # cleanup fields
        mce &= 0xffffffffffe00100L

        return mce

    def __prep_BUS(self, mce):
        # cleanup bytes first
        mce &= 0xffffffffffe00800L

        return mce


    def __gen_dc_mce(self, mce):
        """ Generate a DC MCE signature. Some of the fields are overlapping and
            not valid for all families but this is ok since we want to check the
            error path too when generating an invalid MCE or the MCi_STATUS
            somehow got corrupted
        """

        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            ll  = lls.index(choice(['L1' , 'L2']))

            mce |= 0x1 << 2 | ll  # TT=Data

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            # BD introduces a bunch of EECs != 0
            eec = choice(range(0, 4) + range(16, 20))
            r4  = r4s.index(choice(['GEN', 'DRD', 'DWR', 'EV', 'SNP']))
            ll  = lls.index(choice(['LG', 'L1' , 'L2']))

            mce |= eec << 16 | r4 << 4 | 0x1 << 2 | ll  # TT=Data

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            eec = randint(0, 2)
            pp  = pps.index(choice(['SRC', 'GEN']))
            r4  = r4s.index(choice(['GEN', 'RD', 'DRD', 'DWR']))
            ii  = iis.index(choice(['MEM', 'IO', 'GEN']))

            mce |= eec << 16 | pp << 9 | randint(0, 1) << 8 | r4 << 4 | ii << 2 | 0x3  # LL=LG

        return mce

    def __gen_ic_mce(self, mce):
        """ Generate an IC MCE signature.
        """

        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)
            mce |= lls.index(choice(['L1' , 'L2'])) # TT=Instr, already 0

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = choice(range(0, 11) + [13] + range(16, 21))
            r4  = r4s.index(choice(['IRD', 'SNP', 'EV']))
            ll  = lls.index(choice(['L1' , 'L2', 'LG']))

            mce |= eec << 16 | r4 << 4 | ll # TT=Instr

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            # eec,pp,t,ii already 0
            # IRD, 5
            mce |= 5 << 4 | 3

        return mce


    def __gen_bu_mce(self, mce):
        """ Generate an BU MCE signature
            F12h has all three types based on ErrorCode: TLB, MEM and BUS

        """

        ec = mce & 0xffff
        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            tt = tts.index(choice(['INSN', 'DATA']))

            mce |= tt << 2 | 0x1 # LL=L1

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = randint(0, 3)
            r4 = r4s.index(choice(['GEN', 'RD', 'WR', 'DRD', 'IRD', 'EV', 'SNP']))
            tt = tts.index(choice(['GEN', 'INSN', 'DATA']))
            ll = lls.index(choice(['LG' , 'L2']))

            mce |= eec << 16 | r4 << 4 | tt << 2 | ll

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            r4 = r4s.index(choice(['RD', 'PRF']))
            ii = iis.index(choice(['MEM', 'IO']))

            mce |= r4 << 4 | ii << 2 | 0x3 # LL=LG


        return mce



    def __gen_cu_mce(self, mce):
        """ Generate an OR Combined Unit MCE
        """

        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            mce |= 0x2 << 2 | 0x2 # TT=GEN, LL=L2

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = choice(range(4, 13) + range(16, 21))
            r4  = r4s.index(choice(['DRD', 'IRD', 'PRF' 'DWR', 'SNP', 'EV', 'GEN']))
            tt  = tts.index(choice(['GEN', 'INSN', 'DATA']))
            ll  = lls.index(choice(['LG' , 'L1', 'L2']))

            mce |= eec << 16 | r4 << 4 | tt << 2 | ll

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            eec = randint(0, 2)
            r4  = r4s.index(choice(['RD', 'DWR']))
            ii  = iis.index(choice(['MEM', 'IO']))
            ll  = lls.index(choice(['L1', 'L2']))

            mce |= eec << 16 | r4 << 4 | ii << 2 | ll # PP=SRC, T=0

        return mce


    def __gen_ls_mce(self, mce):
        """ Generate an LS MCE signature
        """

        # LS MCEs are only of type BUS so set bit 11
        mce |= bit(11)

        mce = self.__prep_BUS(mce)
        r4 = r4s.index(choice(['DRD', 'DWR']))
        ii = iis.index(choice(['MEM', 'IO']))

        mce |= r4 << 4 | ii << 2 | 0x3 # LL=LG

        return mce


    def __gen_nb_mce(self, mce):
        """ Generate an NB MCE signature
        """
        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            eec = choice([5, 15]) # GART Err, GART TLB Walk Data Err

            mce |= eec << 16 | 0x2 << 2 | 0x3 # GEN, LG

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = choice([25, 28, 29, 30, 31])
            r4  = r4s.index(choice(['GEN', 'RD', 'WR', 'EV', 'SNP']))
            tt  = tts.index(choice(['GEN', 'DATA']))

            mce |= eec << 16 | r4 << 4 | tt << 2 | 0x3 # LG

        # BUS
        elif ec & 0x0080:
            mce = self.__prep_BUS(mce)

            eec = choice(range(1, 5) + range(6, 16))
            pp  = pps.index(choice(pps))    # yes, all 4 are possible
            r4  = r4s.index(choice(['GEN', 'RD', 'WR', 'DWR']))
            ii  = iis.index(choice(['MEM', 'IO', 'GEN']))

            mce |= eec << 16 | pp << 9 | randint(0, 1) << 8 | r4 << 4 | ii << 2 | 0x3 # LL=LG

        return mce


    def __gen_fr_mce(self, mce):
        """ Generate a FR MCE signature
        """

        # FR/EX MCEs are only of type BUS so set bit 11
        mce |= bit(11)

        # BD-specific
        eec = randint(0, 12)

        mce = self.__prep_BUS(mce)
        mce |= eec << 16 | 0x3 << 9 | randint(0,1) << 8 | 0x3 << 2 | 0x3 # PP=GEN, R4=GEN, II=GEN, LL=LG

        return mce


    def gen_mce(self):
        mce     = getrandbits(64)

        # remove reserved stuff, along with clearing syndrome bits[54:47,31:24]
        mce &= 0xfe006100000fffff

        # Valid
        mce |= bit(63)

        # set CECC, UECC according to bit 61, UC: error couldn't be corrected by hw
        if mce & bit(61):
            mce &= ~bit(46)
            mce |= bit(45)
        else:
            mce |= bit(46)
            mce &= ~bit(45)

        # EN should be always set, otherwise moot
        mce |= bit(60)

        if self.err_type:
            # Clear error type bits so that later we don't get confused
            mce &= 0xfffffffffffff6ef

            if self.err_type == 'TLB':
                mce |= bit(4)
            elif self.err_type == 'MEM':
                mce |= bit(8)
            else:
                mce |= bit(11)

        if self.__is_ecc(mce):
            syndrome = getrandbits(16)
            mce |= ((syndrome & 0x0f) << 47)
            mce |= ((syndrome & 0xf0) << 20)
            self.syndrome = syndrome

        if self.fu == 'DC':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_dc_mce(mce)
        elif self.fu == 'IC':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_ic_mce(mce)
        elif self.fu == 'BU':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_bu_mce(mce)
        elif self.fu == 'CU':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_cu_mce(mce)
        elif self.fu == 'LS':
            mce = self.__gen_ls_mce(mce)
        elif self.fu == 'NB':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_nb_mce(mce)
        elif self.fu == 'FR' or self.fu == 'EX' or self.fu == 'FP':
            mce = self.__gen_fr_mce(mce)

        self.mci_status = mce

    def __is_bit_set(self, bit):
        if bit < 0 or bit > 63:
            return False
        if self.mci_status & (1 << bit):
            return True

        return False

    def valid(self):        return self.__is_bit_set(63)
    def overflow(self):     return self.__is_bit_set(62)
    def uncorrected(self):  return self.__is_bit_set(61)
    def err_enabled(self):  return self.__is_bit_set(60)
    def miscv(self):        return self.__is_bit_set(59)
    def addrv(self):        return self.__is_bit_set(58)
    def pcc(self):          return self.__is_bit_set(57)
    def cecc(self):         return self.__is_bit_set(46)
    def uecc(self):         return self.__is_bit_set(45)
    def scrub(self):        return self.__is_bit_set(40)

    def decode_eec(self):
        return eecs[self.eec()]

    def decode_tt(self):    return tts[(self.mci_status >> 2) & 0x3]
    def decode_ll(self):    return lls[self.mci_status & 0x3]
    def decode_pp(self):    return pps[(self.mci_status >> 9) & 0x3]
    def decode_ii(self):    return iis[(self.mci_status >> 2) & 0x3]

    def decode_r4(self):
        r4 = (self.mci_status >> 4) & 0xf

        if r4 > 8:
            return "-"

        return r4s[r4]

    def decode_t(self):
        t = (self.mci_status >> 8) & 0x1

        if t:
            return "TIMOUT"
        return "NOTIMOUT"

    def error_type(self):
        ec = self.mci_status & 0xffff

        if   (ec & 0xfff0) == bit(4):
            return "TLB(tt:" + self.decode_tt() + ";ll:" + self.decode_ll() + ")"
        elif (ec & 0xff00) == bit(8):
            return "MEM(r4:" + self.decode_r4() + ";tt:" + self.decode_tt() + \
                   ";ll:" + self.decode_ll() + ")"
        elif (ec & 0xF800) == bit(11):
            return "BUS(pp:" + self.decode_pp() + ";t:" + self.decode_t() + \
                   ";r4:"    + self.decode_r4() + ";ii:" + self.decode_ii() + \
                   ";ll:"    + self.decode_ll() + ")"
        else:
            return "WTF?!"

    def __repr__(self):
        ret = []

        if self.valid():        ret.append("Val")
        if self.overflow():     ret.append("Over")
        if self.uncorrected():  ret.append("UC")
        if self.err_enabled():  ret.append("EN")
        if self.miscv():        ret.append("MiscV")
        if self.addrv():        ret.append("AddrV")
        if self.pcc():          ret.append("PCC")
        if self.cecc():         ret.append("CECC")
        if self.uecc():         ret.append("UECC")
        if self.scrub():        ret.append("Scrub")

        dec_bits = '|'.join(ret)

        dec_bits += "|EEC: " + self.decode_eec() + (" (0x%02x)" % (self.eec()))

        if self.__is_ecc():
            dec_bits += (" (synd=0x%04x)" % (self.syndrome))

        dec_bits += "|ET: " + self.error_type()

        return ("MC%d_STATUS[%s]: 0x%016x" % (fus[self.fu], dec_bits, self.mci_status))



def _rw_file(fname, off, flags):
    """ Open and advance into @fname. Don't forget
        to close the fd which this function returns.
    """

    dbg("open %s" % fname)

    try:
        fd = open(fname, flags)
    except:
        err("opening %s" % (fname))
        return -1

    try:
        fd.seek(off, 0)
    except:
        err("skipping to offset %d" % (off))
        close(fd)
        return -1

    return fd

def read_file(fname, off, size):

    fd = _rw_file(fname, off, "rb")
    if fd < 0:
        return -1

    try:
        ret = fd.read(size)
    except:
        err("reading from %s" % fname)
        ret = -1

    fd.close()

    return ret

def write_file(fname, off, value):

    fd = _rw_file(fname, off, "wb")
    if fd < 0:
        return -1

    fd.write(value)
    fd.close()

    return 0

def rdmsr_on_cpu(cpu, msr):
    """ Use kernel /dev/cpu/*/msr interface to access an MSR
    """

    path = "/dev/cpu/%d/msr" % (cpu, )

    val = read_file(path, msr, 8)
    if not val or val < 0:
        err("Unable to read %s." % (path))
        return None

    if len(val) == 8:
        val = struct.unpack("Q", val)[0]
    else:
        err("MSR value truncated")
        return None

    return val

def wrmsr_on_cpu(cpu, msr, val):
    """ Use kernel /dev/cpu/%d/msr interface to write a MSR
    """

    path = "/dev/cpu/%d/msr" % (cpu, )

    packed_val = struct.pack('Q', val)

    if write_file(path, msr, packed_val):
        err("writing 0x%016x to MSR_0x%08x" % (val, msr))

def __toggle_raw_mce_inject(cpu, enable):

    val = rdmsr_on_cpu(cpu, MSR_K7_HWCR)
    if not val:
        return

    dbg("Pre:  0x%016x" % val)

    if enable:
        val |=  bit(18)
    else:
        val &= ~bit(18)

    dbg("Post: 0x%016x" % val)

    wrmsr_on_cpu(cpu, MSR_K7_HWCR, val)

def _inject_raw_mce(cpu, mce):
    """ Inject a raw MCE by writing the MCA registers directly
    """

    bank = fus[mce.fu]

    dbg("bank %d on cpu %d" % (bank, cpu))

    __toggle_raw_mce_inject(cpu, True)

    wrmsr_on_cpu(cpu, MSR_IA32_MCx_STATUS(bank), mce.mci_status)
    wrmsr_on_cpu(cpu, MSR_IA32_MCx_ADDR(bank), 0xbabedeaddeadbeef)
    wrmsr_on_cpu(cpu, MSR_IA32_MCx_MISC(bank), 0xdead57ac1ba0babe)

    if write_file("/sys/inject/cpu", 0, str(cpu)):
        err("injecting RAW MCE")

    __toggle_raw_mce_inject(cpu, False)


def _inject_ecc():
    """ DRAM ECC injection over PCI config space
    """
                 # ArraySelect=1000b | ArrayAddress[2:1]
    array_addr = bit(31) | randint(0, 4) << 1
                 # ErrInjEn[28:20] | EccWrReq | EccVector[15:0] - single-bit errors only for CECC
    array_data = bit(randint(20, 29)) | bit(17)  | bit(randint(0, 16))

    cmd_arr = ['setpci', '-s 18.3', ("0xb8.l=0x%08x" % array_addr)]
    dbg(cmd_arr)

    cmd_dat = ['setpci', '-s 18.3', ("0xbc.l=0x%08x" % array_data)]
    dbg(cmd_dat)

    try:
        subprocess.check_call(cmd_arr)
    except:
        sys.stderr.write("Error running %s\n" % (cmd_arr, ))
        return

    try:
        subprocess.check_call(cmd_dat)
    except:
        sys.stderr.write("Error running %s\n" % (cmd_dat, ));


def _inject_mce(cpu, mce, hw=False):
    """ Injects and MCE error over EDAC's /sysfs
    """

    sysfs_prefix = '/sys/devices/system/edac/mce'

    mce_hw_inject_file  = sysfs_prefix + '/hw_inject'
    mce_status_file     = sysfs_prefix + '/status'
    mce_bank_file       = sysfs_prefix + '/bank'

    if write_file(mce_status_file, 0, ("0x%016x" % (mce.mci_status))):
        print "Cannot open %s" % (mce_status_file)
        print "Have you forgotten modprobing mce_amd_inj.ko?"
        return

    if hw:
        if write_file(mce_hw_inject_file, 0, '1'):
            err("Cannot write to %s" % (mce_hw_inject_file))
            return

    if write_file(mce_bank_file, 0, ("%d" % (fus[mce.fu]))):
            err("Cannot write to %s" % (mce_bank_file))


def inject_mce(opts, mce):
    if opts.i == 'hw':
        _inject_mce(opts.cpu, mce, True)
    elif opts.i == 'ecc':
        _inject_ecc()
    elif opts.i == 'raw':
        _inject_raw_mce(opts.cpu, mce)
    elif opts.i == 'sw':
        _inject_mce(opts.cpu, mce)
    else:
        err("Unknown injection method: %s" % (opts.i, ))

def init_parser():
    """ Read cmdline options

        returns:
        options:dict -- config options
    """

    global opts

    parser = OptionParser()

    parser.add_option(
            "-c",
            "--cpu",
            type="int",
            dest="cpu",
            default=0,
            help="CPU to inject the MCE on",
    )

    parser.add_option(
            "-d",
            "--decode",
            type="string",
            action="store",
            dest="d",
            help="Decode 64-bit MCi_STATUS value representing an MCE"
    )

    parser.add_option(
            "",
            "--dbg",
            dest="dbg",
            action="store_true",
            default=False,
            help="Enable debugging",
    )

    def fam_callback(option, opt_str, value, parser):

        if value == 'R':
            parser.values.f = choice(families)
        elif value in families:
            parser.values.f = value
        else:
            # generate F10h MCEs per default
            parser.values.f = 'f10h'

    parser.add_option(
            "-f",
            "--family",
            dest="f",
            type="string",
            action="callback",
            callback=fam_callback,
            help=("Family to generate MCE for %s" % (families))
    )

    parser.add_option(
            "-i",
            "--inject",
            dest="i",
            type="string",
            help="Inject the error: 'hw' for hardware MCE injection\
                                    'sw' for software-only\
                                    'ecc' for DRAM ECC error\
                                    'raw' for raw MCE injection (needs kernel mod)"
    )

    def et_callback(option, opt_str, value, parser):

        value = value.upper()

        if value not in error_types:
            sys.stderr.write(("WARNING: wrong error type: %s\n" % (value)))

        parser.values.et = value

    parser.add_option(
            "-t",
            "--error-type",
            dest="et",
            type="string",
            action="callback",
            callback=et_callback,
            help=("Generate a specific error type: %s" % (error_types))
    )

    def fu_callback(option, opt_str, value, parser):

        # supplied string could be lowercase
        value = value.upper()

        # randomize FUs
        if value == 'R':
            # don't generate FP MCE yet
            k = fus.keys()
            k.remove('FP')
            parser.values.fu = choice(k)
        elif value in fus.keys():
            parser.values.fu = value

    parser.add_option(
            "-u",
            "--functional-unit",
            dest="fu",
            type="string",
            action="callback",
            callback=fu_callback,
            help=("Functional unit to generate MCE for %s" % (fus.keys())),
    )

    opts = parser.parse_args()[0]
    return opts

def main():

    opts = init_parser()

    if opts.d:
        if opts.fu:
            m = MCE(val=int(opts.d, 16), fu=opts.fu)
            print m
        else:
            err("You need to supply the functional unit this signature belongs to.\n")
            sys.exit(-1)
    else:
        if not opts.fu:
            opts.fu = choice(fus.keys())
            print "Selecting FU at random:", opts.fu

        m = MCE(fu=opts.fu, err_type=opts.et)
        sys.stderr.write(("Generating an %s MCE:\n%s\n" % (opts.fu, m)))

    if opts.i:
        inject_mce(opts, m)

if __name__ == "__main__":
    main()
